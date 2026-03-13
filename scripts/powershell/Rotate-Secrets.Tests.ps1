BeforeAll {
    # Mock Azure modules to avoid requiring actual Azure connection
    function Get-AzContext { return @{ Subscription = @{ Name = 'TestSub' } } }
    function Get-AzKeyVault { param($VaultName) return @{ VaultName = $VaultName } }
    function Get-AzKeyVaultSecret {
        param($VaultName, $Name)
        return @(
            [PSCustomObject]@{
                Name = 'test-secret'
                Expires = (Get-Date).AddDays(3)
                Updated = (Get-Date).AddDays(-100)
                Version = 'v1'
            }
        )
    }
    function Set-AzKeyVaultSecret { param($VaultName, $Name, $SecretValue, $Expires, $Tag, $ContentType) return @{ Version = 'v2' } }
    function Get-AzWebApp { return @() }
    function Restart-AzWebApp { }
    function Import-Module { }

    $ScriptPath = "$PSScriptRoot/Rotate-Secrets.ps1"
}

Describe 'Rotate-Secrets Script' {

    Context 'Script file validation' {
        It 'Script file should exist' {
            Test-Path $ScriptPath | Should -Be $true
        }

        It 'Script should have valid PowerShell syntax' {
            $errors = $null
            [System.Management.Automation.PSParser]::Tokenize(
                (Get-Content $ScriptPath -Raw), [ref]$errors
            )
            $errors.Count | Should -Be 0
        }

        It 'Script should use CmdletBinding' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match '\[CmdletBinding\('
        }

        It 'Script should support ShouldProcess' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match 'SupportsShouldProcess\s*=\s*\$true'
        }
    }

    Context 'Parameter validation' {
        It 'Should have VaultName parameter' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match '\$VaultName'
        }

        It 'Should have SecretName parameter' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match '\$SecretName'
        }

        It 'Should have DaysBeforeExpiry parameter with default of 7' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match '\$DaysBeforeExpiry\s*=\s*7'
        }

        It 'Should have Emergency switch parameter' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match '\[switch\]\$Emergency'
        }
    }

    Context 'Script functions' {
        It 'Should define Write-Log function' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match 'function Write-Log'
        }

        It 'Should define Test-AzureConnection function' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match 'function Test-AzureConnection'
        }

        It 'Should define Get-SecretsToRotate function' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match 'function Get-SecretsToRotate'
        }

        It 'Should define Invoke-SecretRotation function' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match 'function Invoke-SecretRotation'
        }

        It 'Should define Send-RotationNotification function' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match 'function Send-RotationNotification'
        }
    }

    Context 'Security best practices' {
        It 'Should use SecureString for password handling' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match 'ConvertTo-SecureString'
        }

        It 'Should set expiration on rotated secrets' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match '-Expires'
        }

        It 'Should tag secrets with rotation metadata' {
            $content = Get-Content $ScriptPath -Raw
            $content | Should -Match "'RotatedOn'"
            $content | Should -Match "'RotatedBy'"
            $content | Should -Match "'PreviousVersion'"
        }
    }
}
