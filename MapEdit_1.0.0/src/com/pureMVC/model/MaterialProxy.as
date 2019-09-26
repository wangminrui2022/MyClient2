/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.pureMVC.model
{
	import com.map.Objects;
	import com.mapfile.vo.MMaterialDefinitionVO;
	import com.pureMVC.view.ui.as_.OnlyImage;
	import com.vo.material.MaterialTileVO;
	import com.vo.material.MaterialVO;
	
	import flash.display.Loader;
	import flash.events.ContextMenuEvent;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * 材质模型层
	 * @author wangmingfan
	 */
	public class MaterialProxy extends Proxy
	{
		public static const NAME:String="MaterialProxy";
		
		//【序列化】材质平铺数组(MaterialTileVO)
		[Bindable]
		public var materialTileArr:ArrayCollection;	
				
		public function MaterialProxy(data:Object=null)
		{
			super(NAME, data);
		}		
		/**
		 * 添加材质平铺对象
		 * @param materialVO
		 */
		public function addMaterialTileArr(materialVO:MaterialVO):void
		{
			for each(var mdVO:MMaterialDefinitionVO in materialVO.MaterialDefinitionVOArr)
			{
				for each(var ld:Loader in materialVO.LoaderArr)
				{
					try
					{
						if (ld.contentLoaderInfo.applicationDomain.getDefinition(mdVO.diffuse))
						{
							var mtlVO:MaterialTileVO=new MaterialTileVO();
							mtlVO.mdVO=mdVO;
							mtlVO.mClass=ld.contentLoaderInfo.applicationDomain.getDefinition(mdVO.diffuse) as Class;					
							materialTileArr.addItem(mtlVO);
							ld=null;
							break;
							
						}					
					}
					catch(er:Error)
					{
						//清理LoaderInfo对象
						ld=null;
						continue;						
					}
				}
			}
			materialVO=null;
		}
		/**
		 * 删除材质平铺对象
		 * @param name
		 * @return 
		 */
		public function deleteMaterialTileVO(name:String):Boolean
		{
			for(var i:int=0;i<materialTileArr.length;i++)
			{
				var tmp:MaterialTileVO=materialTileArr[i];
				if(tmp.mdVO.name==name)
				{
					//清理材质平铺对象
					tmp.mClass=null;
					tmp.mdVO=null;
					if(tmp.roadArr)
						tmp.roadArr.splice(0,tmp.roadArr);
					tmp.roadArr=null;
					tmp=null;
					materialTileArr.removeItemAt(i);
					return true;
				}
				tmp=null;
			}
			return false;
		}		
		/**
		 * 获得平铺材质
		 * @param name
		 * @return 
		 */
		public function getMaterialTileVO(name:String):MaterialTileVO
		{
			for each(var mTileVO:MaterialTileVO in materialTileArr)
			{
				if(mTileVO.mdVO.name==name)
				{
					return mTileVO;
				}
			}		
			return null;			
		}
		/**
		 * 获得平铺材质的Class定义
		 * @param definition
		 * @return 
		 */
		public function getClass(diffuse:String):Class
		{
			for each(var mTileVO:MaterialTileVO in materialTileArr)
			{
				if(mTileVO.mdVO.diffuse==diffuse)
				{
					return mTileVO.mClass;
				}
			}		
			return null;
		}
		/**
		 * 获取选择的材质对象
		 * @param e
		 * @return 
		 */
		public function getOnlyImage(e:ContextMenuEvent):OnlyImage
		{
			if(e.mouseTarget is OnlyImage)
				return e.mouseTarget as OnlyImage;
			else if(e.mouseTarget.parent is OnlyImage)
				return e.mouseTarget.parent as OnlyImage; 
			else if(e.mouseTarget.parent.parent is OnlyImage)
				return e.mouseTarget.parent.parent as OnlyImage
			else
				return null;
		}
		/**
		 * 获得放置到地图中的Objects对象
		 * @param e
		 * @return 
		 */		
		public function getMapObjects(e:ContextMenuEvent):Objects
		{
			if(e.mouseTarget is Objects)
				return e.mouseTarget as Objects;
			else if(e.mouseTarget.parent is Objects)
				return e.mouseTarget.parent as Objects;
			else if(e.mouseTarget.parent.parent is Objects)
				return e.mouseTarget.parent.parent as Objects;
			else if(e.mouseTarget.parent.parent.parent is Objects)
				return e.mouseTarget.parent.parent.parent as Objects;
			else 
				return null;	
		}						
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			if(materialTileArr)
			{
				var len:int=materialTileArr.length;
				for(var i:int=0;i<len;i++)
				{
					var mTileVO:MaterialTileVO=materialTileArr.getItemAt(0) as MaterialTileVO;
					mTileVO.mClass=null;
					mTileVO.mdVO=null;
					if(mTileVO.roadArr)
						mTileVO.roadArr.splice(0,mTileVO.roadArr.length);
					mTileVO.roadArr=null;
					mTileVO.obstacleRect=null;
					mTileVO=null;
					materialTileArr.removeItemAt(0);
				}
			}
			materialTileArr=null;
		}					
	}
}