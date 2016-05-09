class Property:
    mtype = "property"
    
class PropertyDate(Property):
    mtype = "propertydate"
    
class PropertyString(Property):
    mtype = "propertystring"
    
class PropertyImage(Property):
    mtype = "propertyimage"
    
class PropertyDynamic(Property):
    mtype = "propertydynamic"

class PropertyContent(Property):
    mtype = "propertycontent"
    
class PropertyList(Property):
    mtype = "propertylist"
    
    def __init__(self,subtype):
        self.msubtype = subtype

class Post:
    def __init__(self):
        self.mdate    = PropertyDate()
        self.mtitle   = PropertyString()
        self.mcontent = PropertyContent()

class PostImage:
    def __init__(self):
        self.mdate        = PropertyDate()
        self.mtitle       = PropertyString()
        self.mimage       = PropertyImage()
        self.mdescription = PropertyString()

class PostDynamic:
    def __init__(self):
        self.mdate        = PropertyDate()
        self.mtitle       = PropertyString()
        self.mdynamic     = PropertyDynamic()
        self.mdescription = PropertyString()

        
class Project:
    def __init__(self):
        self.mdate        = PropertyDate()
        self.mtitle       = PropertyString()
        self.mworks       = PropertyList(PostImage)
    
