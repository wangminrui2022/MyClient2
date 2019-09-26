package com.myclient2sample3.pureMVC.controller.business.mapoperate
{
	import com.myclient2.core.engine.MObjects;
	import com.myclient2sample3.consts.MapOperates;
	import com.myclient2sample3.pureMVC.controller.business.engine.ClearMapCommand;
	import com.myclient2sample3.pureMVC.controller.business.engine.InitEngineCommand;
	import com.myclient2sample3.pureMVC.model.EngineProxy;
	import com.myclient2sample3.pureMVC.model.MapOperateProxy;
	import com.myclient2sample3.pureMVC.model.RoleProxy;
	import com.myclient2sample3.pureMVC.model.UIProxy;
	import com.myclient2sample3.vo.MapConvertVO;
	
	import flash.geom.Rectangle;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 地图切换
	 * @author 王明凡
	 */
	public class MapConvertCommand extends SimpleCommand
	{
		public static const MCC_MAP_CONVERT:String="mcc_map_convert";

		private var mapOperateP:MapOperateProxy;
		
		private var roleP:RoleProxy;
		
		private var uiP:UIProxy;
		
		private var engineP:EngineProxy;
		
		public function MapConvertCommand()
		{
			mapOperateP=this.facade.retrieveProxy(MapOperateProxy.NAME) as MapOperateProxy;
			roleP=this.facade.retrieveProxy(RoleProxy.NAME) as RoleProxy;
			uiP=this.facade.retrieveProxy(UIProxy.NAME) as UIProxy;
			engineP=this.facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;
		}
		override public function execute(note:INotification):void
		{
			for each (var oj:MObjects in mapOperateP.MapOperateMObjectsArr)
			{
				switch (oj.ojVO.id)
				{
						case MapOperates.hb001_MapConvert_object_236:
							onMapConvertCheck(oj);
							break;
						case MapOperates.hb001_MapConvert_object_241:
							onMapConvertCheck(oj);
							break;
							
						case MapOperates.map002_MapConvert_object_107:
							onMapConvertCheck(oj);
							break;
						case MapOperates.map002_MapConvert_object_104:
							onMapConvertCheck(oj);
							break;		
							
						case MapOperates.map003_MapConvert_object_61:
							onMapConvertCheck(oj);
							break;
						case MapOperates.map003_MapConvert_object_57:
							onMapConvertCheck(oj);
							break;													
				}
				oj=null;
			}
			mapOperateP=null;
			roleP=null;
			uiP=null;
			engineP=null;
		}
		/**
		 * 地图切换检查
		 * @param oj
		 */
		private function onMapConvertCheck(oj:MObjects):void
		{
			var ojRect:Rectangle;	
			try
			{
				ojRect=oj.getBounds(uiP.mapOperateContainer); 
				var cx:int;
				var cy:int;
				if(roleP.moveDirection>0)
				{
					cx=roleP.role2.x-(roleP.role2.width>>1);
					cy=roleP.role2.y;					
				}
				else
				{
					cx=roleP.role2.x+(roleP.role2.width>>1);
					cy=roleP.role2.y;
				}
				//如果角色和地图切换对象相交	
				if(ojRect.contains(cx,cy))
				{
					var mcVO:MapConvertVO=uiP.getMapConvertVO(engineP.map.info.name,oj.ojVO.id);	
					//清理地图垃圾
					this.sendNotification(ClearMapCommand.CMC_CLEAR_MAP);
					//初始化Engine模型层
					this.sendNotification(InitEngineCommand.IEC_INIT_ENGINE_COMMAND,mcVO);					
				}				
			}catch(er:Error)
			{
				trace(er.message);
			}
			oj=null;	
			ojRect=null;
		}
	}
}