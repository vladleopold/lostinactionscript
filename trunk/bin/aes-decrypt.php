<?php 
  // from www.movable-type.co.uk/scripts/aes-php.html 

  require 'aes-lib.php';  
  
  echo AESDecryptCtr($_POST['encrypted'], $_POST['key'], 256);
?> 