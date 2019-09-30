package com.model
{
	import com.vo.BasicLoaderVO;
	import com.vo.MaterialDefinitionVO;
	import com.vo.MaterialInfoVO;
	import com.vo.MaterialNodeVO;
	
	import flash.display.LoaderInfo;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * 
	 * @author 王明凡
	 */
	public class MaterialProxy extends Proxy
	{
		public static const NAME:String="MaterialProxy";
		//材质信息
		[Bindable]
		public var miVO:MaterialInfoVO;
		//材质节点集合
		[RemoteClass]
		public var materialNodeVOArr:Array;
		
		public function MaterialProxy(data:Object=null)
		{
			super(NAME, data);
		}
		/**
		 * 设置材质节点LoaderInfo属性
		 * @param blVO
		 */
		public function setMaterialNodeArrLoaderInfo(blVO:BasicLoaderVO):void
		{
			for each(var tmp:MaterialNodeVO in materialNodeVOArr)
			{
				if(tmp.label==blVO.name)
				{
					tmp.loaderInfo=blVO.loaderInfo;
					blVO=null;
					return;
				}
			}
		}
		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			miVO.name=null;
			miVO.savePath=null;
			miVO.serializablePath=null;
			miVO.materialPath=null;
			miVO.materialXML=null;
			if(miVO.MaterialDefinitionVOArr)
				miVO.MaterialDefinitionVOArr.splice(0,miVO.MaterialDefinitionVOArr.length);
			miVO.MaterialDefinitionVOArr=null;
			miVO=null;
			if(materialNodeVOArr)
				materialNodeVOArr.splice(0,materialNodeVOArr.length);
			materialNodeVOArr=null;
			
		}
		/**
		 * 获得材质类定义
		 * @param diffuse
		 * @return 
		 */
		public function getMaterialNodeVOClass(diffuse:String):Class
		{
			var tmp:Class;
			for each(var i:MaterialNodeVO in materialNodeVOArr)
			{
				try
				{
					tmp=i.loaderInfo.applicationDomain.getDefinition(diffuse) as Class;
				}catch(er:Error)
				{
					continue;
				}			
			}
			return tmp;
		}
		/**
		 * 搜索节点MaterialDefinitionVO
		 * @param name
		 * @return 
		 */
		public function getMaterialDefinitionVO(name:String):MaterialDefinitionVO
		{
			for each(var i:MaterialDefinitionVO in miVO.MaterialDefinitionVOArr)
			{
				if(i.name==name)
				{
					return i;
				}
			}
			return null;
		}
		/**
		 * 删除节点MaterialDefinitionVO
		 * @param name
		 */
		public function deleteMaterialDefinitionVO(name:String):void
		{
			for(var i:int;i<miVO.MaterialDefinitionVOArr.length;i++)
			{
				if(miVO.MaterialDefinitionVOArr[i].name==name)
				{
					miVO.MaterialDefinitionVOArr.splice(i,1);
					return;
				}
			}
		}
		/**
		 *  获得<materialDefinition>节点字符串
		 * @param mdVO
		 * @return 
		 */
		public function getMaterialDefinitionString(mdVO:MaterialDefinitionVO):String
		{
			var xml:XML=<materialDefinition></materialDefinition>;
			xml.@name=mdVO.name;
			xml.@type=mdVO.type;
			xml.@used=mdVO.used;
			xml.@width=mdVO.width;
			xml.@height=mdVO.height;
			xml.@elementType=mdVO.elementType;
			xml.appendChild(<diffuse/>);
			xml.diffuse=mdVO.diffuse;
			return xml.toXMLString();
		}		
		/**
		 *  返回材质节点对象
		 * @param label
		 * @param loaderInfo
		 * @return 
		 */
		public function getMaterialNodeVO(label:String,loaderInfo:LoaderInfo):MaterialNodeVO
		{
			var mVO:MaterialNodeVO=new MaterialNodeVO();
			mVO.label=label;
			mVO.loaderInfo=loaderInfo;
			return mVO
		}		
	}
}