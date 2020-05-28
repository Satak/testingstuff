
function ConvertTo-Base64 {
  [alias('tb64')]
  [CmdletBinding()]
  param(
    [Parameter(
      Position = 0,
      Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true)
    ]
    [string]$Value
  )

  return [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Value))
}

# auth: https://developer.github.com/v3/#authentication
# updating file: https://developer.github.com/v3/repos/contents/

$url = 'https://api.github.com/repos/satak/testingstuff/contents/test.json'
$Token = $env:GITHUB_TOKEN

$res = Invoke-RestMethod -Uri $url

$newContent = @{
  name = 'Something New $(Get-Random)'
  date = (Get-Date).DateTime
} | ConvertTo-Json | ConvertTo-Base64

$body = @{
  'message'   = 'Update file'
  'committer' = @{
    'name'  = '<name>'
    'email' = '<youremail>@domain.com'
  }
  'content'   = $newContent
  'sha'       = $res.sha
} | ConvertTo-Json


$APIWebRequestParams = @{
  Uri         = $url
  Method      = 'Put'
  Body        = $body
  ContentType = 'application/json; charset=utf-8'
  Headers     = @{Authorization = "Token $Token" }
}

Invoke-RestMethod @APIWebRequestParams
