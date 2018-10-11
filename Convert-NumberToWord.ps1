Function Convert-NumberToWord {
  [CmdletBinding(DefaultParameterSetName = 'Default')]
  param(
    [ Parameter( 
      Position = 0, 
      Mandatory = $True, 
      ParameterSetName = 'Default',
      ValueFromPipeline = $True)
    ]
    [ValidateNotNullOrEmpty()]
    [int64]$NumbertoConvert
  )
  begin{}
  process{
    $one   = @{ '0'='zero '; '1'='one '; '2'='two '; '3'='three '; '4'='four '; '5'='five '; '6'='six '; '7'='seven '; '8'='eight '; '9'='nine ' }
    $two   = @{ '1'='ten '; '2'='twenty '; '3'='thirty '; '4'='fourty '; '5'='fifty '; '6'='sixty '; '7'='seventy '; '8'='eighty '; '9'='ninety ' }
    $teen  = @{ '1'='eleven '; '2'='twelve '; '3'='thirteen '; '4'='fourteen '; '5'='fifteen '; '6'='sixteen '; '7'='seventeen '; '8'='eighteen '; '9'='ninteen ' }
    $place = @{ '1'='hundred '; '2'='thousand, '; '3'='million, '; '4'='billion, '; '5'='trillion, '; '6'='quadrillion, '; '7'='quintillion, '; '8'='sextillion, '; '9'='septillion, '; '10'='octillion, '; '11'='nonillion, '; '12'='decillion, ' }
    $numberString = '{0:0,0}' -f $NumbertoConvert
    if ( $numberString[0] -eq "0" ){
      $numberString = $numberString.Substring(1)
    }
    $numberArray = @($numberString.Split(','))
    $numberarray = for ($i = $numberArray.Count - 1; $i -ge 0 ; $i--) {
      $numberArray[$i]
    }

    $return = `
      for ($i = $numberArray.count; $i -gt 0; $i--) {
        if ( $numberArray.count -eq 1 ){
          switch ($numberArray.Length){
            "3" { 
                  $first = $one[ ($numberArray[0]).ToString() ] + " " + $place["1"]
                  $second = `
                    switch ( $numberArray[1] ){
                      "1" {
                            switch ( $numberArray[2] ){
                              "0" { $two["1"] }
                              default { $teen[ $numberArray[2].ToString() ] }
                            }
                          }
                      default {
                        if ( $numberArray[1] -ne '0' ) {
                          $two[$numberArray[1].ToString()]
                        }
                        else { $null }
                      }
                    }
                  $third = `
                    if ( $numberArray[1] -ne "1" -and $numberArray[2] -ne "0" ) {
                      $one[ $numberArray[2].ToString() ]
                    }
                  $first + $second + $third
                }
            "2" {
                  $second = `
                  switch ( $numberArray[0] ){
                    "1" {
                          switch ( $numberArray[1] ){
                            "0" { $two["1"] }
                            default { $teen[ $numberArray[1].ToString() ] }
                          }
                        }
                    default {
                          $two[ $numberArray[0].ToString() ]
                        }
                  }
                  $third = `
                    if ( $numberArray[0] -ne "1" -and $numberArray[1] -ne "0" ) {
                      $one[ $numberArray[1].ToString() ]
                    }
                  $second + $third
                }
            "1" {
                  $one[ ($numberArray["0"]).ToString() ]
                }
          }
        }
        else {
          switch ( $numberArray[$i - 1].Length ){
            "3" { 
                  $first = $one[ ($numberArray[$i - 1][0]).ToString() ] + $place["1"]
                  $second = `
                    switch ( $numberArray[$i - 1][1] ){
                      "1" {
                            switch ( $numberArray[$i - 1][2] ){
                              "0" { $two["1"] }
                              default { $teen[ $numberArray[$i - 1][2].ToString() ] }
                            }
                          }
                      default {
                        if ( $numberArray[$i - 1][1] -ne '0' ) {
                          $two[$numberArray[$i - 1][1].ToString()]
                        }
                        else { $null }
                      }
                    }
                  $third = `
                    if ( $numberArray[$i - 1][1] -ne "1" -and $numberArray[$i - 1][2] -ne "0" ) {
                      $one[ $numberArray[$i - 1][2].ToString() ]
                    }
                  if ( $i -ne 1 ){
                    $first + $second + $third + $place[$i.ToString()]
                  }
                  else {
                    $first + $second + $third
                  }
                }
            "2" {
                  $second = `
                  switch ( $numberArray[$i - 1][0] ){
                    "1" {
                          switch ( $numberArray[$i - 1][1] ){
                            "0" { $two["1"] }
                            default { $teen[ $numberArray[$i - 1][1].ToString() ] }
                          }
                        }
                    default {
                          $two[ $numberArray[$i - 1][0].ToString() ]
                        }
                  }
                  $third = `
                    if ( $numberArray[$i - 1][0] -ne "1" -and $numberArray[$i - 1][1] -ne "0" ) {
                      $one[ $numberArray[$i - 1][1].ToString() ]
                    }
                  if ($i -ne 1){
                    $second + $third + $place[$i.ToString()]
                  }
                  else {
                    $second + $third
                  }
                }
            "1" {
                  $third = $one[ ($numberArray[$i - 1]["0"]).ToString() ]
                  if ( $i -ne 1 ){
                    $third + $place[$i.ToString()]
                  }
                  else {
                    $third
                  }
                }
          }
        }
      }
  }
  end{
    $return = [string]$return 
    return $return
  }
}
