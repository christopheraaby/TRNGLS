package {

	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.net.*;
	import flash.geom.*;
	import flash.geom.ColorTransform;

	public class Trngls extends MovieClip {

		// PUBLIC / GLOBAL VARS //
		static var WIDTH:uint = 600;
		static var HEIGHT:uint = 600;

		static var trngls:MovieClip = new MovieClip();

		// GRAPHICAL CONTAINERS //
		var superContainer:Sprite = new Sprite();
		var triangleContainer1:Sprite = new Sprite();
		var triangleContainer2:Sprite = new Sprite();
		var triangleContainer3:Sprite = new Sprite();
		var triangleContainer4:Sprite = new Sprite();

		// COLOR LAYER //
		var colorLayer1:Shape = new Shape();
		var colorLayer0:Shape = new Shape();

		// SLIDERS //
		static var slider1:SliderUI;
		static var slider2:SliderUI;
		static var slider3:SliderUI;

		public function Trngls() {
			// VARIABLES //
			triangleContainer1.x = WIDTH / 2;
			triangleContainer1.y = HEIGHT / 2;
			triangleContainer2.x = WIDTH / 2;
			triangleContainer2.y = HEIGHT / 2;
			triangleContainer3.x = WIDTH / 2;
			triangleContainer3.y = HEIGHT / 2;
			triangleContainer4.x = WIDTH / 2;
			triangleContainer4.y = HEIGHT / 2;

			// COLOR LAYER SETUP //
			colorLayer0.graphics.beginFill(0x000000);
			colorLayer0.graphics.drawRect(-1000, -1000, 2000, 2000);
			
			var matr:Matrix = new Matrix();
			matr.createGradientBox(2000, 1000, (270 / 360 * Math.PI * 2), 0, 0);
			colorLayer1.graphics.beginGradientFill(GradientType.LINEAR, [0x001133, 0x446688, 0x88FFFF], [1, 1, 1], [0, 127, 255], matr);
			colorLayer1.graphics.drawRect(-1000, -1000, 2000, 2000);
			colorLayer1.blendMode = BlendMode.OVERLAY;

			// UI SETUP //
			btnGenerateNew.addEventListener(MouseEvent.CLICK, exportPNG);

			slider1 = new SliderUI(stage, "x", track1, handle1, 0, 1, 0);
			slider2 = new SliderUI(stage, "x", track2, handle2, 0.01, 3, 0.5);
			slider3 = new SliderUI(stage, "x", track3, handle3, 0.01, 80, 5);

			trngls = this;

			generateNew("falseEvent");//function receives one untyped argument, usually an event, here just a dummy
		}

		// EXTERNAL FUNCTIONS //
		function getUint(min, max):uint {
			return Math.floor(Math.random() * max - min + min) + 1;
		}

		function isEven(num:Number):String {
			var returnValue:String;
			num % 2 ? returnValue = "false" : returnValue = "true";
			return returnValue;
		}

		public function drawTriangles(targetContainer:Sprite) {
			var x1:Number = 0;
			var y1:Number = 0;
			var x2:Number = 0;
			var y2:Number = 0;
			var x3:Number = 0;
			var y3:Number = 0;
			var a:Number = 1;

			var triSize:Number = 0.25;
			var numLayers:int = 100;
			var layer:int = 0;
			var dir:int = 1;

			for (layer = 0; layer <= numLayers; layer++) {
				for (dir = 1; dir <= 3; dir++) {
					a = 0.5 - (0.5 * layer / numLayers);
					x1 = layer * dir * Math.cos(layer * dir) * slider3.currentValue;
					y1 = layer * dir * Math.sin(layer * dir) * slider3.currentValue;
					x2 = Math.abs(layer * dir) * slider1.currentValue;
					y2 = Math.abs(layer * dir) * slider1.currentValue;
					x3 = (x1 - 50) * slider2.currentValue;
					y3 = (y1 + 50) * slider2.currentValue;
					var instance:Triangle = new Triangle(x1,y1,x2,y2,x3,y3,a);
					targetContainer.addChild(instance);
				}
			}
		}
		public function fillContainers() {
			// TIME TO MAKE TRIANGLES //
			for (var fourDir:int = 0; fourDir <= 1; fourDir++) {
				if (fourDir == 0) {
					drawTriangles(triangleContainer1);
				}
				if (fourDir == 1) {
					drawTriangles(triangleContainer2);
				}
				if (fourDir == 2) {
					drawTriangles(triangleContainer3);
				}
				if (fourDir == 3) {
					drawTriangles(triangleContainer4);
				}

				addChildAt(superContainer, 0);

				superContainer.x = -700;
				superContainer.y = -700;
				colorLayer0.x = 1000;
				colorLayer0.y = 1000;
				colorLayer1.x = 1000;
				colorLayer1.y = 1000;
				triangleContainer1.x = 1000;
				triangleContainer1.y = 1000;
				triangleContainer2.x = 1000;
				triangleContainer2.y = 1000;
				//triangleContainer3.x = 1000;
				//triangleContainer3.y = 1000;
				//triangleContainer4.x = 1000;
				//triangleContainer4.y = 1000;

				triangleContainer1.rotation = 0;
				triangleContainer2.rotation = 90;
				//triangleContainer3.rotation = 180;
				//triangleContainer4.rotation = 270;

				superContainer.addChild(colorLayer0);
				superContainer.addChild(triangleContainer1);
				superContainer.addChild(triangleContainer2);
				//superContainer.addChild(triangleContainer3);
				//superContainer.addChild(triangleContainer4);
				superContainer.addChild(colorLayer1);
			}
		}

		public function generateNew(e):void {
			while (triangleContainer1.numChildren) {
				triangleContainer1.removeChildAt(0);
			}
			while (triangleContainer2.numChildren) {
				triangleContainer2.removeChildAt(0);
			}
			while (triangleContainer3.numChildren) {
				triangleContainer3.removeChildAt(0);
			}
			while (triangleContainer4.numChildren) {
				triangleContainer4.removeChildAt(0);
			}
			while (superContainer.numChildren) {
				superContainer.removeChildAt(0);
			}
			fillContainers();
		}

		public function exportPNG(whatEvent) {
			var pngSource:BitmapData = new BitmapData (2000, 2000, false, 0x333333);
			pngSource.draw(superContainer);

			var pngEncoder:PNGEnc = new PNGEnc();
			var pngStream:ByteArray = pngEncoder.encode(pngSource);

			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var pngURLRequest:URLRequest = new URLRequest("png_encoder_download.php?name=trngls.png");
			pngURLRequest.requestHeaders.push(header);
			pngURLRequest.method = URLRequestMethod.POST;
			pngURLRequest.data = pngStream;
			navigateToURL(pngURLRequest, "_self");//should maybe use "_blank"
		}
	}
}