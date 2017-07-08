
#
# DEPRECATED !!!! NOT USED ANYMORE !!!!
#

source worktemplate2.tcl

set template {	
<!DOCTYPE html>
<html lang="en-US"> 
    
<head>

    <meta charset="UTF-8" />
    <meta name="description" content="Generative Dots Art by Julien Leonard" />
    <meta name="author" content="Julien Leonard" />
    <meta name="keywords" content="generative,dots,art,circles" />
    <link rel="shortcut icon" type="image/png" href="/favicon.png">        

    <!-- Mobile Specific Metas ================================================== -->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

   <!--[if lt IE 7 ]><html class="ie ie6" lang="en"> <![endif]-->
   <!--[if IE 7 ]><html class="ie ie7" lang="en"> <![endif]-->
   <!--[if IE 8 ]><html class="ie ie8" lang="en"> <![endif]-->
   <!--[if gte IE 9 ]><html class="no-js ie9" lang="en"> <![endif]-->
    
   <title>Julien Leonard - Generative Dots Art</title>
	
    <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->


    <!-- CSS ================================================== -->

    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/layout.css">

    <link href='http://fonts.googleapis.com/css?family=Cousine:400italic,400,700,700italic' rel='stylesheet' type='text/css'>
    
    <script type="text/javascript" src="javascript/jquery.min.js"></script>

    <script>
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-85603200-1', 'auto');
    ga('send', 'pageview');

    </script>

</head>

<body class="home blog custom-background">
   <div class="container">

      %HEADER%

      <div class="content">
         %CONTENT%    
      </div>

      %FOOTER%

   </div>                                        
</body>
</html>           
}

set templates [list $template $worktemplate]
