package com.myclient2sample1.pureMVC.controller.business.mapoperate
{
	import com.myclient2.core.engine.MObjects;
	import com.myclient2.core.vo.MObjectsVO;
	import com.myclient2sample1.pureMVC.controller.business.engine.ClickMapCommand;
	import com.myclient2sample1.pureMVC.model.EngineProxy;
	import com.myclient2sample1.pureMVC.model.MapOperateProxy;
	import com.myclient2sample1.pureMVC.model.UIProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	

	/**
	 * 初始化地图操作对象模型
	 * @author wangmingfan
	 */
	public class InitMapOperateCommand extends SimpleCommand
	{
		public static const IMOC_INIT_MAP_OPERATE:String="imoc_init_map_operate";
		
		private var uiP:UIProxy;
		
		private var engineP:EngineProxy;
		
		private var mapOperateP:MapOperateProxy;
		
		public function InitMapOperateCommand()
		{
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
			mapOperateP=this.facade.retrieveProxy(MapOperateProxy.NAME) as MapOperateProxy;
		}
		override public function execute(note:INotification):void
		{
			//创建地图操作对象		
			mapOperateP.MapOperateMObjectsArr=new Array();			
			for each (var ojVO:MObjectsVO in engineP.engine.clippingOperateArr)
			{
				var oj:MObjects=getMObjects(ojVO);
				oj.x=oj.ojVO.x;
				oj.y=oj.ojVO.y;
				uiP.mapOperateContainer.addChild(oj);
				mapOperateP.MapOperateMObjectsArr.push(oj);
				oj=null;
			}	
			uiP=null;					
			engineP=null;
			mapOperateP=null;
			//监听单击地图事件
			this.sendNotification(ClickMapCommand.CMC_CLICK_MAP);								
		}
		/**
		 * 将切换场景对象添加到场景并返回
		 * @param ojVO
		 * @return 
		 */
		private function getMObjects(ojVO:MObjectsVO):MObjects
		{
			var oj:MObjects=new MObjects();
			oj.onDisplay(ojVO,engineP.map.SWFLoaderArr);
			ojVO=null;
			return oj;		
		}						
	}
}