package com.pureMVC.controller.business.ui
{
	import com.maptype.vo.RoadVO;
	
	import com.consts.MString;
	import com.pureMVC.model.BindableProxy;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.model.UIProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 交换UI1和UI2的深度
	 * @author wangmingfan
	 */
	public class SwitchDepthCommand extends SimpleCommand
	{
		//交换地图中UI1和UI2的深度
		public static const SDC_SWITCH_DEPTH:String="sdc_switch_depth";
				
		private var bindableP:BindableProxy;
				
		private var uiP:UIProxy;
		
		private var mapP:MapProxy;
		
		public function SwitchDepthCommand()
		{
			bindableP=this.facade.retrieveProxy(BindableProxy.NAME) as BindableProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
		}
		override public function execute(note:INotification):void
		{
			if(bindableP.switchMenuEnabled)
			{
				if(uiP.mainUI.getChildIndex(uiP.ui1)==0 && uiP.mainUI.getChildIndex(uiP.ui2)==1)
				{
					if(note.getBody()!="UI1=0,UI2=1")
					{
						uiP.mainUI.setChildIndex(uiP.ui2,0);
						setRoadColor("A",mapP.map.info.tileHeight);
					}
				}
				else if(uiP.mainUI.getChildIndex(uiP.ui1)==1 && uiP.mainUI.getChildIndex(uiP.ui2)==0)
				{
					if(note.getBody()!="UI1=1,UI2=0")
					{
						uiP.mainUI.setChildIndex(uiP.ui2,1);
						setRoadColor("B",mapP.map.info.tileHeight);
					}
				}
			}
			bindableP=null;
			uiP=null;	
			mapP=null;	
		}
		/**
		 * 设置路点颜色
		 * @param drawType
		 * @param tileH
		 */
		private function setRoadColor(drawType:String,tileH:int):void
		{
			for(var y:int=0;y<mapP.map.roadArr.length;y++)
			{
				for(var x:int=0;x<mapP.map.roadArr[0].length;x++)
				{
					var rVO:RoadVO=mapP.map.roadArr[y][x] as RoadVO;
					if(rVO.type==0)
					{
						rVO=null;
						continue;
					}
					var color:int;
					if(drawType=="A")
					{
						if(rVO.type==1)
							color=MString.OBSTACLE;
						else if(rVO.type==2)
							color=MString.SHADOW;					
					}
					else
					{
						color=MString.PASS;
					}
					rVO.shape.graphics.clear();
					rVO.shape.graphics.beginFill(color, 0.7);
					rVO.shape.graphics.drawCircle(rVO.point.x, rVO.point.y, tileH >>2);
					rVO.shape.graphics.endFill();
					rVO=null;
				}
			}
		}
	}
}