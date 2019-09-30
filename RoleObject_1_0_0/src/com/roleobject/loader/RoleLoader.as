package com.roleobject.loader
{
	import com.roleobject.vo.DefinitionsVO;
	import com.roleobject.vo.DiffuseVO;
	import com.roleobject.vo.MaterialDefinitionVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoaderDataFormat;
	
	/**
	 * 角色加载
	 * @author 王明凡
	 */
	public class RoleLoader extends EventDispatcher
	{
		private var _definitionsVO:DefinitionsVO;
		
		public function RoleLoader()
		{
			_definitionsVO=new DefinitionsVO();
		}
		public function get definitionsVO():DefinitionsVO
		{
			return _definitionsVO;
		}		
		public function onLoader(url:String):void
		{
			var bl:BasicLoader=new BasicLoader();
			bl.addEventListener(Event.COMPLETE, onComplete);
			bl.addEventListener(IOErrorEvent.IO_ERROR, onIoError);	
			bl.onLoaderURL(url,URLLoaderDataFormat.BINARY);		
		}
		public function clear():void
		{
			_definitionsVO=null;
		}
		/**
		 * 
		 * @param e
		 */
		private function onComplete(e:Event):void
		{
			var bl:BasicLoader=e.currentTarget as BasicLoader;
			var xml:XML=XML(bl.getByte());
			definitionsVO.mediaArr=getMediaArr(xml);
			definitionsVO.materialDefinitionVOArr=getMaterialDefinitionVOArr(xml);
			xml=null;
			clearBasicLoader(bl);
			bl=null;	
			//循环加载角色材质
			var rmloader:RoleMaterialLoader=new RoleMaterialLoader();
			rmloader.addEventListener(Event.COMPLETE, onRoleMaterialLoaderComplete);
			rmloader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			rmloader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			rmloader.onRoleMaterialLoader(definitionsVO.mediaArr);		
			rmloader=null;	
		}	
		/**
		 * 角色材质加载完成
		 * @param e
		 */
		private function onRoleMaterialLoaderComplete(e:Event):void
		{
			var rmloader:RoleMaterialLoader=e.currentTarget as RoleMaterialLoader;
			definitionsVO.loaderArr=rmloader.getLoaderArr();
			clearRoleMaterialLoader(rmloader);
			rmloader=null;
			this.dispatchEvent(e);
		}	
		/**
		 * 进度
		 * @param e
		 */
		private function onProgress(e:ProgressEvent):void
		{
			this.dispatchEvent(e);		
		}				
		/**
		 * 异常
		 * */
		private function onIoError(e:IOErrorEvent):void
		{
			if(e.currentTarget is BasicLoader)
				clearBasicLoader(e.currentTarget as BasicLoader);
			else if(e.currentTarget is RoleMaterialLoader)
				clearRoleMaterialLoader(e.currentTarget as RoleMaterialLoader);
		}		
		/**
		 * 垃圾清理 MBasicLoader
		 * */
		private function clearBasicLoader(bl:BasicLoader):void
		{
			bl.removeEventListener(Event.COMPLETE, onComplete);
			bl.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			bl.clear();
			bl=null;
		}
		/**
		 * 垃圾清理 RoleMaterialLoader
		 * @param parseScene
		 */
		private function clearRoleMaterialLoader(rmLoader:RoleMaterialLoader):void
		{
			rmLoader.removeEventListener(Event.COMPLETE, onRoleMaterialLoaderComplete);
			rmLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			rmLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			rmLoader.clear();
			rmLoader=null;
		}					
		/**
		 * 获得材质src地址集合
		 * @param xml
		 * @return 
		 */
		private function getMediaArr(xml:XML):Array
		{
			var tmp:Array=new Array();
			for each(var i:XML in xml.media)
			{
				tmp.push(i.@src.toXMLString());
				i=null;
			}
			return tmp;			
		}
		/**
		 * 获得材质定义对象集合
		 * @param xml
		 * @return 
		 */
		private function getMaterialDefinitionVOArr(xml:XML):Array
		{
			var tmp:Array=new Array();
			for each(var i:XML in xml.materialDefinition)
			{
				var mdVO:MaterialDefinitionVO=new MaterialDefinitionVO();
				mdVO.name=i.@name.toXMLString();
				mdVO.type=i.@type.toXMLString();
				if(mdVO.type==MaterialDefinitionVO.TYPE_2)
					mdVO.diffuse=i.@diffuse.toXMLString();
				mdVO.diffuseVOArr=getDiffuseVOArr(i);
				tmp.push(mdVO);
				mdVO=null;
				i=null;
			}
			return tmp;
		}
		/**
		 * 获得类定义对象集合
		 * @param xml
		 * @return 
		 */
		private function getDiffuseVOArr(xml:XML):Array
		{
			var tmp:Array=new Array();
			for each(var i:XML in xml.diffuse)
			{
				var dVO:DiffuseVO=new DiffuseVO();
				dVO.direct=int(i.@direct.toXMLString());
//				dVO.width=int(i.@width.toXMLString());
//				dVO.height=int(i.@height.toXMLString());
				dVO.diffuse=i;
				tmp.push(dVO);
				dVO=null;
				i=null;
			}	
			return tmp;		
		}			
	}
}