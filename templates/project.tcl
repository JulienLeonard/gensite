set worktemplate {    <div class="one-third column">
      <div class="post">
	<a href="%LINK%"><img width="1024" height="1024" src="%IMAGEURL%" class="attachment-large size-large wp-post-image" alt="%ALT%" srcset="%IMAGEURL1024% 1024w, %IMAGEURL150% 150w, %IMAGEURL550% 550w" sizes="(max-width: 1024px) 100vw, 1024px" /></a>                				
	<div class="title">  
          <a href="%LINK%" title="%TITLE%">%TITLE%</a>
	</div>	
      </div> 	
    </div>	}


set template {	
<!DOCTYPE html>
<html lang="en-US"> 
    
<head>

    <meta charset="UTF-8" />
    <meta name="description" content=" DOTS2ART | %TITLE% " />
    <meta name="author" content="Julien Leonard" />
    <meta name="keywords" content="generativeart,javascript,python,circlepacking,ann" />
    <link rel="shortcut icon" type="image/png" href="/favicon.png">        
        
<!--[if lt IE 7 ]><html class="ie ie6" lang="en"> <![endif]-->
<!--[if IE 7 ]><html class="ie ie7" lang="en"> <![endif]-->
<!--[if IE 8 ]><html class="ie ie8" lang="en"> <![endif]-->
<!--[if gte IE 9 ]><html class="no-js ie9" lang="en"> <![endif]-->
    
    <title>DOTS2ART - Serie %TITLE% </title>
        
	<!--[if lt IE 9]>
		<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->

	<!-- Mobile Specific Metas ================================================== -->
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

	<!-- CSS ================================================== -->

	<link rel="stylesheet" href="css/base.css">
	<link rel="stylesheet" href="css/style.css">
	<link rel="stylesheet" href="css/layout.css">

    <!-- <link href='http://fonts.googleapis.com/css?family=Cousine:400italic,400,700,700italic' rel='stylesheet' type='text/css'> -->
    <link href="https://fonts.googleapis.com/css?family=Bellefair" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Ubuntu" rel="stylesheet">
    
        <script type="text/javascript" src="javascript/jquery.min.js"></script>

    <!-- analytics -->
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
