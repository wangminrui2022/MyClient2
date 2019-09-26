package com.pureMVC.view.ui.as_
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Label;
	
	import com.pureMVC.controller.business.common.PageClearCommand;
	import com.pureMVC.core.AppFacade;
	import com.vo.material.MaterialTileVO;

	public class TileImage extends VBox
	{
		public var dataProvider:ArrayCollection;
		//指定每张图片宽
		public var imageW:int;
		//指定每张图片高
		public var imageH:int;

		private var pageSum:int;
		private var rowSum:int;
		private var rowNow:int;
		private var i:int;
		private var labHeight:int=25;

		public function TileImage()
		{

		}
		/**
		 * 垃圾清理
		 * */
		public function clear():void
		{
			pageSum=0;
			rowSum=0;
			rowNow=0;
			i=0;
			if (this.numChildren>0)
			{
				AppFacade.getInstace().sendNotification(PageClearCommand.PC_PAGECLEAR, this, "3");
			}			
			

		}
		/**
		 * 平铺显示材质
		 */
		public function onTileImage():void
		{
			clear();
			rowSum=dataProvider.length;
			rowNow=int(this.width / imageW);
			pageSum=getPageSum(rowSum, rowNow);

			for (var y:int=0; y < pageSum; y++)
			{
				var bY:HBox=getHBox(this.width,imageH+labHeight,1);
				for (var x:int=0; x < rowNow; x++)
				{
					if (i < rowSum)
					{
						var bX:VBox=getVBox(imageW,imageH+labHeight,1);
						var mTileVO:MaterialTileVO=dataProvider.getItemAt(i) as MaterialTileVO;
						var onlyImage:OnlyImage=new OnlyImage();
						onlyImage.width=imageW;
						onlyImage.height=imageH;
						onlyImage.mTileVO=mTileVO;
						bX.addChild(onlyImage);
						bX.addChild(getLabel(mTileVO.mdVO.name,imageW,labHeight));
						bY.addChild(bX);
						bX=null;
						mTileVO=null;
						onlyImage=null;
						i++;
					}
					else
					{
						break;
					}
				}
				this.addChild(bY);
				bY=null;
			}

		}
		/**
		 * 获得HBox
		 * @param width
		 * @param height
		 * @param gap
		 * @return 
		 */
		private function getHBox(width:int, height:int, gap:int):HBox
		{
			var hbox:HBox=new HBox()
			hbox.horizontalScrollPolicy="off";
			hbox.verticalScrollPolicy="off";
			hbox.width=width;
			hbox.height=height;
			hbox.setStyle("verticalGap", gap);
			return hbox;			
		}
		/**
		 * 获得VBox
		 * @param width
		 * @param height
		 * @param gap
		 * @return 
		 */
		private function getVBox(width:int, height:int, gap:int):VBox
		{
			var vbox:VBox=new VBox();
			vbox.horizontalScrollPolicy="off";
			vbox.verticalScrollPolicy="off";
			vbox.width=width;
			vbox.height=height;
			vbox.setStyle("verticalGap", gap);
			vbox.addEventListener(MouseEvent.MOUSE_MOVE, onVBoxMouseMove);
			vbox.addEventListener(MouseEvent.MOUSE_OUT, onVBoxMouseOut);
			return vbox;
		}

		/**
		 * 鼠标移过
		 * */
		private function onVBoxMouseMove(e:MouseEvent):void
		{
			e.currentTarget.buttonMode=true;
			e.currentTarget.setStyle("borderStyle", "solid");
			e.currentTarget.setStyle("borderColor", "#5f5f64");
		}

		/**
		 * 鼠标移走
		 * */
		private function onVBoxMouseOut(e:MouseEvent):void
		{
			e.currentTarget.buttonMode=false;
			e.currentTarget.setStyle("borderStyle", "none");
			e.currentTarget.setStyle("borderColor", "");
		}
		/**
		 * 返回Label
		 * @param txt
		 * @param width
		 * @param height
		 * @return 
		 */
		private function getLabel(txt:String,width:int, height:int):Label
		{
			var lab:Label=new Label();
			lab.text=txt;
			lab.width=width;
			lab.height=height;
			return lab;
		}
		/**
		 * 获得总页数
		 */
		private function getPageSum(rowSum:int, rowNow:int):int
		{
			if (rowSum % rowNow == 0)
				return rowSum / rowNow;
			else
				return int(rowSum / rowNow) + 1;
		}

	}
}