<!DOCTYPE html>
<html>
<body>
  <?php
    $rake_out = array();
    $jekyll_out = array();
    $headers = getallheaders();
    if (isset($headers['Secret']) && $headers['Secret'] == "aso_loves_rubyship-jekyll-and-contentful")
    {
      chdir("../jekyll/ncp/");
      exec("../../ruby_ship/bin/rake contentful", $rake_out);
      exec("../../ruby_ship/bin/jekyll b", $jekyll_out);
    }
    else
    {
      $rake_out[] = "Not executed";
      $jekyll_out[] = "Not executed";
    }
  ?>

  <h1>Completed</h1>

  <h4>Rake output</h4>
  <pre><?php foreach($rake_out as $line) print("$line\n"); ?> </pre>

  <h4>Jekyll build</h4>
  <pre><?php foreach($jekyll_out as $line) print("$line\n"); ?> </pre>
</body>
</html>
