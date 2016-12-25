proc h1 {title} {
    return "<h1>$title</h1>"
}

proc h2 {title} {
    return "<h2>$title</h2>"
}

proc h3 {title} {
    return "<h3>$title</h3>"
}


proc img {src} {
    return "<img src=\"${src}\"/>"
}

proc section {content} {
    return "<section>${content}</section>"
}

proc a {link content} {
    return "<a href=\"$link\">${content}</a>"
}

proc p {content} {
    return "<p>$content</p>"
}

proc div {class content} {
    return "<div class=\"$class\">$content</div>"
}
