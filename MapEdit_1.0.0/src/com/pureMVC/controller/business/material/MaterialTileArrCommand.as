/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.material
{
	import flash.display.Loader;
	
	import com.consts.MString;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.model.MaterialProxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import com.vo.material.MaterialTileVO;

	/**
	 * 材质平铺数组
	 * @author 王明凡
	 */
	public class MaterialTileArrCommand extends SimpleCommand
	{
		public static const MTC_MATERIALTILEARR:String="mtc_materialtilearr";

		public static const MTC_MATERIALTILEARR_COMPLETE:String="mtc_materialtilearr_complete";

		private var materialP:MaterialProxy;
		
		private var mapP:MapProxy;
		
		private var type:String;

		public function MaterialTileArrCommand()
		{
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
		}

		override public function execute(note:INotification):void
		{
			type=note.getType();
			setMaterialTileArrClass(note.getBody() as Array);
		}

		/**
		 * 1.设置平铺材质对象集合中的mClass属性
		 * 2.将Object类型路点数组转成RoadVO类型路点数组
		 */
		public function setMaterialTileArrClass(LoaderArr:Array):void
		{
			try
			{
				for each (var mTileVO:MaterialTileVO in materialP.materialTileArr)
				{
					mTileVO.mClass=getMaterialTileClass(mTileVO.mdVO.diffuse, LoaderArr);
					if (mTileVO.mdVO.type == MString.OBJECT && mTileVO.roadArr)
						mTileVO.roadArr=mTileVO.roadArr;
				}			
			}catch(er:Error)
			{
				clear(LoaderArr);
				this.sendNotification(MTC_MATERIALTILEARR_COMPLETE,false,type);
				return;
			}
			clear(LoaderArr);
			this.sendNotification(MTC_MATERIALTILEARR_COMPLETE,true,type);
		}
		/**
		 * 搜索材质类
		 * @param diffuse
		 * @param LoaderInfoArr
		 * @return
		 */
		public function getMaterialTileClass(diffuse:String, LoaderArr:Array):Class
		{
			for each (var ld:Loader in LoaderArr)
			{
				try
				{
					if (ld.contentLoaderInfo.applicationDomain.getDefinition(diffuse))
					{
						var cls:Class=ld.contentLoaderInfo.applicationDomain.getDefinition(diffuse) as Class;
						LoaderArr=null;
						return cls;
					}
				}
				catch (er:Error)
				{
					continue;
				}
			}
			LoaderArr=null;
			return null;
		}
		/**
		 * 卸载加载的swf，并且清理垃圾
		 * @param LoaderArr
		 */
		private function clear(LoaderArr:Array):void
		{
			if (LoaderArr)
			{
				for each (var ld:Loader in LoaderArr)
				{
					ld.unloadAndStop();
					ld=null;
				}
				LoaderArr.splice(0, LoaderArr.length);
			}		
			LoaderArr=null;
			materialP=null;
			mapP=null;			
		}		
	}
}