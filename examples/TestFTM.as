package {
	import com.ryan.geom.FreeTransformEvent;
	import com.ryan.geom.FreeTransformManager;
	import com.gskinner.motion.GTweener;
	import com.gskinner.motion.easing.*;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.ColorPicker;
	import fl.controls.Slider;
	import fl.events.ColorPickerEvent;
	import fl.events.SliderEvent;
	import fl.motion.easing.Circular;
	import flash.text.TextFieldAutoSize;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
  import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.filters.ColorMatrixFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	public class TestFTM extends MovieClip {
		
		private static var _instance:TestFTM;
		public static function get instance():TestFTM {
			return _instance;
		}
		
		public var fts:FreeTransformManager;
		
		//controls
		public var txtX:TextField;
		public var txtY:TextField;
		public var txtW:TextField;
		public var txtH:TextField;
		public var txtRotate:TextField;
		public var txtScale:TextField;
		public var txtQuad:TextField;
		public var txtDAngle:TextField;
		public var sliderRotate:Slider;
		public var sliderScale:Slider;
		public var colorHandleOutline:ColorPicker;
		public var colorHandleFill:ColorPicker;
		public var colorBBoxOutline:ColorPicker;
		public var txtHandleOutlineThickness:TextField;
		public var txtHandleRadius:TextField;
		public var txtBoundingBoxThickness:TextField;
		
		
		public function TestFTM():void {
			_instance = this;
			
			// Set up FreeTransformManager
			fts = new FreeTransformManager(false);
			
			fts.boundingBoxOutlineThickness = 2;
			fts.handleRadius = 5;
			fts.handleOutlineThickness = 0.5;
			
			//dustParent.addChild(dustballs);
			//dustballs.x = 0; dustballs.y = 0;
			
			container.addChild(testObj);
			container.addChild(dog);
			container.addChild(dustballs);
			container.addChild(txtObj);
			
			// Register objects
			fts.registerSprite(testObj, { minScale:0.5, maxScale:1.5 } );
			fts.registerSprite(dog, { minW:50, maxW:500 } );
			fts.registerSprite(dustballs, { minH:50, maxH:1000 } );
			fts.registerSprite(txtObj);
			
			
			//Embed fonts so that text show up.
			txtObj.embedFonts = true;
			testObj.innerText.embedFonts = true;
			txtObj.autoSize = TextFieldAutoSize.LEFT;
			
			
			
			// Linking up controls
			txtX = panelSettings._txtX;
			txtY = panelSettings._txtY;
			txtW = panelSettings._txtW;
			txtH = panelSettings._txtH;
			txtRotate = panelSettings._txtRotate;
			txtScale = panelSettings._txtScale;
			txtQuad = panelSettings._txtQuad;
			txtDAngle = panelSettings._txtDAngle;
			
			sliderRotate = panelSettings.sliderRotate;			
			sliderScale = panelSettings.sliderScale;
			colorHandleOutline = panelSettings.colorHandleOutline;
			colorHandleFill = panelSettings.colorHandleFill;
			colorBBoxOutline = panelSettings.colorBBoxOutline;
			txtHandleOutlineThickness = panelSettings._txtHandleOutlineThickness;
			txtHandleRadius = panelSettings._txtHandleRadius;
			txtBoundingBoxThickness = panelSettings._txtBoundingBoxThickness;
			
			
			// Setting up events
			fts.addEventListener(FreeTransformEvent.ON_TRANSFORM, onTransform);
			
			panelSettings.btnTogglePanel.addEventListener(MouseEvent.CLICK, function() {
				if (panelSettings.y < 0){
					GTweener.to(panelSettings, 0.7, {x:290, y:0}, {ease:Exponential.easeInOut});
				}else{
					GTweener.to(panelSettings, 0.7, {x:290, y:-437}, {ease:Exponential.easeInOut});
				}
			});
			
			panelSettings.btnChangeText.addEventListener(MouseEvent.CLICK, function() {
				fts.enabled = false;
				txtObj.text += '\ntest';
				fts.enabled = true;
				trace(txtObj.text);
			});
			
			panelSettings.btnShowInteresting.addEventListener(MouseEvent.MOUSE_DOWN, onDownShowInteresting);
			panelSettings.btnHide.addEventListener(MouseEvent.MOUSE_DOWN, onDownHide);
			panelSettings.btnBTT.addEventListener(MouseEvent.MOUSE_DOWN, onDownBTT);
			
			panelSettings.btnSetSize.addEventListener(MouseEvent.MOUSE_DOWN, onDownSetSize);
			panelSettings.btnSetW.addEventListener(MouseEvent.MOUSE_DOWN, onWChange);
			panelSettings.btnSetH.addEventListener(MouseEvent.MOUSE_DOWN, onHChange);
			
			
			panelSettings.btnSetR.addEventListener(MouseEvent.MOUSE_DOWN, onDownSetR);
			panelSettings.btnAddObj.addEventListener(MouseEvent.MOUSE_DOWN, onDownAddObj);
			panelSettings.btnAddTextObj.addEventListener(MouseEvent.MOUSE_DOWN, onDownAddTextObj);
			
			panelSettings.btnToggleEnabled.addEventListener(MouseEvent.MOUSE_DOWN, onToggleEnabled);
			panelSettings.btnDelete.addEventListener(MouseEvent.MOUSE_DOWN, onDownDelete);
			panelSettings.btnLoadObj.addEventListener(MouseEvent.MOUSE_DOWN, onDownLoadObj);
			panelSettings.btnNestObj.addEventListener(MouseEvent.MOUSE_DOWN, onDownNestObj);
			panelSettings.btnChangeColor.addEventListener(MouseEvent.MOUSE_DOWN, onDownChangeColor);
			
			panelSettings.btnDeRegDog.addEventListener(MouseEvent.MOUSE_DOWN, onDeRegDog);
			panelSettings.btnDragLimit.addEventListener(MouseEvent.MOUSE_DOWN, function(evt:MouseEvent) {
				if (fts.dragArea){
          fts.dragArea = null;
          (evt.target as Button).label = 'Limit to Rect';
        }else{
          fts.dragArea = new Rectangle(50,50,200,200);
          (evt.target as Button).label = 'Remove Limit';
        }
			});
			
			sliderRotate.addEventListener(SliderEvent.CHANGE, onSliderRotateDrag);
			sliderScale.addEventListener(SliderEvent.CHANGE, onSliderScaleDrag);
			
			txtX.addEventListener(Event.CHANGE, onTChange);
			txtY.addEventListener(Event.CHANGE, onTChange);
			
			// Colors and thickness of UI elements
			
			colorHandleOutline.selectedColor = fts.handleOutlineColor;
			colorHandleFill.selectedColor = fts.handleFillColor;
			colorBBoxOutline.selectedColor = fts.boundingBoxOutlineColor;
			
			colorHandleOutline.addEventListener(ColorPickerEvent.CHANGE, onCChange);
			colorHandleFill.addEventListener(ColorPickerEvent.CHANGE, onCChange);
			colorBBoxOutline.addEventListener(ColorPickerEvent.CHANGE, onCChange);
			
			txtHandleOutlineThickness.addEventListener(Event.CHANGE, onCChange);
			txtHandleRadius.addEventListener(Event.CHANGE, onCChange);
			txtBoundingBoxThickness.addEventListener(Event.CHANGE, onCChange);
			
			txtHandleOutlineThickness.text = fts.handleOutlineThickness.toString();
			txtHandleRadius.text = fts.handleRadius.toString();
			txtBoundingBoxThickness.text = fts._boundingBoxOutlineThickness.toString();
		}
		
		protected function onTransform(evt:FreeTransformEvent):void {
			txtX.text = evt.x.toFixed(2);
			txtY.text = evt.y.toFixed(2);
			txtRotate.text = evt.rotationInDeg.toFixed(2);
			txtScale.text = evt.scale.toFixed(2);
			
			txtW.text = evt.targetObject.width.toFixed(2);
			txtH.text = evt.targetObject.height.toFixed(2);
			
			sliderRotate.value = evt.rotationInDeg;
			sliderScale.value = evt.scale * sliderScale.maximum;
		}
		
		protected function onDownShowInteresting(evt:MouseEvent):void {
			fts.showInterestingStuff = !(evt.target as CheckBox).selected;
		}
		
		protected function onDownHide(evt:MouseEvent):void {
			if ((panelSettings.btnHide as CheckBox).selected) {
				fts.visible = true;
			}else {
				fts.visible = false;
			}
		}
		
		protected function onDownBTT(evt:MouseEvent):void {
			if ((panelSettings.btnBTT as CheckBox).selected) {
				fts.bringTargetToTop = false;
			}else {
				fts.bringTargetToTop = true;
			}
		}
		
		
		
		protected function onDownSetSize(evt:MouseEvent):void {
			fts.setSize(parseInt(txtW.text), parseInt(txtH.text));
		}
		
		protected function onDownSetR(evt:MouseEvent):void {
			var randomRotation:Number = (Math.random() * 360) - 180;
			randomRotation = randomRotation * (Math.PI / 180);
			trace('randomRotation=' + randomRotation);
			fts.setRotate(randomRotation);
			
			fts.getDispObj().x = Math.random() * 200;
			fts.updateAfterChange();
		}
		
		protected function onDownAddObj(evt:MouseEvent):void {
			var temp:MovieClip = new TestObj2();
			temp.x = Math.random() * 300;
			temp.y = Math.random() * 300;
			addChild(temp);
			fts.registerSprite(temp);
		}
		
		protected function onDownAddTextObj(evt:MouseEvent):void {
			var fontSans:FontSans = new FontSans();
			var fmt:TextFormat = new TextFormat(fontSans.fontName, 16, 0x003366);
			var tf:TextField = new TextField();
			tf.defaultTextFormat = fmt;
			tf.embedFonts = true;
			var now:Date = new Date();
			tf.text = "New text! Time now is " + now.toUTCString();
			tf.width = 150;
			tf.height = 80;
			tf.border = false;
			tf.multiline = true;
			tf.selectable = false;
			tf.wordWrap = true;
			tf.x = 25;
			tf.y = 20;
			var temp:MovieClip = new MovieClip();
			temp.graphics.beginFill(0x8fb7f8, 1);
			temp.graphics.drawRect(0, 0, 200, 120);
			temp.graphics.endFill();
			temp.addChild(tf);
			temp.x = Math.random() * 300;
			temp.y = Math.random() * 300;
			temp.filters = testObj.filters;
			stage.addChild(temp);
			
			fts.registerSprite(temp);
		}
		
		protected function onDownLoadObj(evt:MouseEvent):void {
			
			var url:String = 'http://ryantan.net/content/FTM/nekobus.jpg';
			var imageLoader:Loader;
			imageLoader = new Loader();
			imageLoader.load(new URLRequest(url));
			imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, imageLoading);
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);

			var temp:MovieClip = new MovieClip();
			
			function imageLoaded(e:Event):void {
				temp.addChild(imageLoader);
				temp.x = Math.random() * 300;
				temp.y = Math.random() * 300;
				temp.filters = testObj.filters;
				stage.addChild(temp);
				fts.registerSprite(temp);
			}
			 
			function imageLoading(e:ProgressEvent):void {
				//show load progress
			}
		}
		
		protected function onDownNestObj(evt:MouseEvent):void {
			dustballs.x = (dog.width - dustballs.width) / 2;
			dustballs.y = (dog.height - dustballs.height) / 2;
			dog.addChild(dustballs);
		}
		
		protected function onDownChangeColor(evt:MouseEvent):void{
			
			//var myColor:ColorTransform = dustballs.transform.colorTransform;
			//myColor.color = 0xFF0000;
			//dustballs.transform.colorTransform = myColor;
			
			var newColorTransform:ColorTransform = fts.transform.colorTransform;
			newColorTransform.color = 0xFF0000;
			fts.transform.colorTransform = newColorTransform;
			
			var matrix:Array = new Array();
			matrix=matrix.concat([0,1,0,0,0]);// red
			matrix=matrix.concat([0,0,1,0,0]);// green
			matrix=matrix.concat([1,0,0,0,0]);// blue
			matrix=matrix.concat([0,0,0,1,0]);// alpha
			var my_filter:ColorMatrixFilter=new ColorMatrixFilter(matrix);
			//fts.filters = [my_filter];
			dustballs.filters = [my_filter];
		}
		
		protected function onToggleEnabled(evt:MouseEvent):void {
			fts.enabled = !fts.enabled;
			if (fts.enabled) {
				(evt.target as Button).label = 'Disable';
			}else {
				(evt.target as Button).label = 'Enable';
			}
		}
		
		protected function onDownDelete(evt:MouseEvent):void {
			var targetObj:DisplayObject = fts.getDispObj();
			fts.deregisterSprite(targetObj);
			targetObj.parent.removeChild(targetObj);
		}
		
		protected function onDeRegDog(evt:MouseEvent):void {
			fts.deregisterSprite(dog);
		}
		
		protected function onSliderRotateDrag(evt:SliderEvent):void {
			fts.setRotateDeg(evt.value);
		}
		
		
		protected function onSliderScaleDrag(evt:SliderEvent):void {
			fts.setScale(evt.value / sliderScale.maximum);
		}
		
		protected function onTChange(evt:Event):void {
			fts.setPos(parseInt(txtX.text), parseInt(txtY.text));
		}
		
		protected function onWChange(evt:Event):void {
			fts.setWidth(parseInt(txtW.text));
		}
		
		protected function onHChange(evt:Event):void {
			fts.setHeight(parseInt(txtH.text));
		}
		
		protected function onCChange(evt:Object):void {
			fts.handleOutlineColor = colorHandleOutline.selectedColor;
			fts.handleFillColor = colorHandleFill.selectedColor;
			fts.boundingBoxOutlineColor = colorBBoxOutline.selectedColor;
			
			fts.handleOutlineThickness = parseFloat(txtHandleOutlineThickness.text);
			fts.handleRadius = parseFloat(txtHandleRadius.text);
			fts._boundingBoxOutlineThickness = parseFloat(txtBoundingBoxThickness.text);
		}
		
	}
}