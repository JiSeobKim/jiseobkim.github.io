<?php

  $response = Array();

  $response['hp'] = '01012341234';
  $response['name'] = 'KJS';
  $response['age'] = 27;
  $response['data1'] = "data1";
  $response['data2'] = "data2";
  $response['data3'] = "data3";
  $response['data4'] = "data4";
  $response['data5'] = "data5";
  $response['data6'] = "data6";
  $response['data7'] = "data7";
  $response['data8'] = "data8";


  echo json_encode($response,JSON_UNESCAPED_UNICODE);
?>
