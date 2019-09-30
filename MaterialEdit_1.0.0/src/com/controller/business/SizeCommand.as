package com.controller.business
{
	import com.vo.SizeVO;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 计算两个矩形的相对尺寸(A相对B,A的缩放值)
	 * @author 王明凡
	 */
	public class SizeCommand extends SimpleCommand
	{
		//(通知)
		public static const SIZE:String="size";

		public function SizeCommand()
		{
			super();
		}
		override public function execute(note:INotification):void
		{
			var sVO:SizeVO=note.getBody() as SizeVO;
			var max:String=getMaxWH(sVO.A,sVO.B);
			if(max=="width")
			{
				var tmpW:int=sVO.A.width-(sVO.A.width-sVO.B.width);
				var pW:Number=tmpW/sVO.A.width;//计算比例
				
				sVO.A.width=tmpW;
				sVO.A.height=pW*sVO.A.height;
			}
			else if(max=="height")
			{
				var tmpH:int=sVO.A.height-(sVO.A.height-sVO.B.height);
				var pH:Number=tmpH/sVO.A.height;//计算比例
				sVO.A.height=tmpH;	
				sVO.A.width=pH*sVO.A.width;		
			}
			//居中
			sVO.A.x=(sVO.B.width-sVO.A.width)/2;
			sVO.A.y=(sVO.B.height-sVO.A.height)/2;
			
			sVO=null;
		}

		/**
		 * 返回最大的尺寸(宽或者高或者null)
		 * @param A
		 * @param B
		 * @return 
		 */
		private function getMaxWH(A:DisplayObject,B:DisplayObject):String
		{
			var w:int;
			var h:int;
			if(A.width>B.width)
				w=A.width-B.width;
			if(A.height>B.height)
				h=A.height-B.height;
			if(w>h)
				return "width";
			else if(h>w)
				return "height";
			else if(w==h && (w>0 && h>0))
				return "width"
			else
				return "null";
		}				
	}
}