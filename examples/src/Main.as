package
{
	import com.ryan.geom.FreeTransformManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextInteractionMode;
	
	public class Main extends Sprite
	{
		//
		[Embed(source="220px-Lenna.png")]
		private var imgCls:Class;
		//
		private var txtObj:TextField = new TextField();
		//
		private var fts:FreeTransformManager;
		//
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
		}
		
		private function addToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStageHandler);
			//
			var container:Sprite = new Sprite();
			var photo:Bitmap  = new imgCls();
			//
//			txtObj.embedFonts = true;
//			txtObj.textInteractionMode = TextInteractionMode.SELECTION;
			txtObj.type = TextFieldType.INPUT;
			txtObj.text = "AAABBBCCC";
			txtObj.autoSize = TextFieldAutoSize.LEFT;
//			container.addChild(photo);
			container.addChild(txtObj);
			this.addChild(container);
			// Set up FreeTransformManager
			fts = new FreeTransformManager(false);
			
			fts.boundingBoxOutlineThickness = 2;
			fts.handleRadius = 5;
			fts.handleOutlineThickness = 0.5;
			
			//dustParent.addChild(dustballs);
			//dustballs.x = 0; dustballs.y = 0;
			
			// Register objects
			fts.registerSprite(container, { minScale:0.5, maxScale:1.5 } );
//			fts.registerSprite(container, { minW:50, maxW:500 } );
//			fts.registerSprite(container, { minH:50, maxH:1000 } );
//			fts.registerSprite(container);
		}
		
	}
}