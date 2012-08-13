package as3.utils {
    public function deepTrace( obj : *, level : int = 0 ) : void{
        var tabs : String = "";
        for ( var i : int = 0 ; i < level ; i++, tabs += "\t" );
        
        for ( var prop : String in obj ){
            trace( tabs + "[" + prop + "] -> " + obj[ prop ] );
            deepTrace( obj[ prop ], level + 1 );
        }
    }
}