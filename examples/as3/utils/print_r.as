// ActionScript file
package as3.utils {
    public function print_r(obj:*, level:int = 0, output:String = ""):* {
	    var tabs:String = "";
	    for(var i:int = 0; i < level; i++, tabs += "\t");
	   
	    for(var child:* in obj){
	        output += tabs +"["+ child +"] => "+ obj[child];
	       
	        var childOutput:String = print_r(obj[child], level+1);
	        if(childOutput != '') output += ' {\n'+ childOutput + tabs +'}';
	       
	        output += "\n";
	    }
	   
	   	/*
	    if(level == 0) Alert.show(output);
	    else return output;
	    */
	    return output;
	}
}