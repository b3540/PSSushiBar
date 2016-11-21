#
# Module manifest
#
@{
    GUID = 'c1720150-5512-4622-886a-79f08ada55d8'
    ModuleVersion = '1.0'
    Description = '🍣'

    Author = 'stknohg'
    CompanyName = 'stknohg'
    Copyright = '(c) 2016 stknohg. All rights reserved.'

    # CompatiblePSEditions is supported PS5.1 later
    # CompatiblePSEditions = @('Desktop')
    NestedModules = @('PSSushiBar.psm1')

    # TypesToProcess = @()
    # FormatsToProcess = @()
    FunctionsToExport = @('Start-SushiBar', 'Stop-SushiBar')
    #AliasesToExport = @()

    PrivateData = @{
        PSData = @{
            # Tags = @()
            # LicenseUri = ''
            # ProjectUri = ''
            # IconUri = ''
            # ReleaseNotes = ''
        }
    }
}