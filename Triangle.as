package {
	import flash.display.*;

	public class Triangle extends Sprite {

		var triangle:Shape = new Shape();

		public function Triangle(x1,y1,x2,y2,x3,y3,a) {
			triangle.graphics.beginFill(0xFFFFFF, 1);
			triangle.graphics.moveTo(x1, y1);
			triangle.graphics.lineTo(x2, y2);
			triangle.graphics.lineTo(x3, y3);
			triangle.graphics.lineTo(x1, y1); //Check to see if this can be removed
			triangle.graphics.endFill();
			addChild(triangle);
			triangle.alpha = a;
		}
	}
}