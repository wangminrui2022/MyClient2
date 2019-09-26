/**
 * MyClient2地图编辑器 - Copyright (c) 2010 黑色闪电工作室 www.heiseshandian.com
 */
package com.basic
{
	import flash.display.*;
	import flash.events.*;

	import com.vo.material.MaterialVO;

	/**
	 * 加载材质类
	 * @author wangmingfan
	 */
	public class MaterialLoader extends ExtendLoader
	{	
		//材质文件swf的Loader对象集合
		private var LoaderArr:Array;
		//材质XML
		private var xml:XML;
		//材质对象
		private var materialVO:MaterialVO;
		//材质字节数组集合对象
		private var byteVOArr:Array;
		//加载总数
		private var sumLoad:int;
		//循环加载材质错误
		protected var loopError:Boolean;		
		//材质加载数量		
		protected var loadCount:int=0; 
				
		public function MaterialLoader()
		{
			LoaderArr=new Array();
			byteVOArr=new Array();
			materialVO=new MaterialVO();
		}

		/**
		 * 开始加载
		 * @param oj
		 */
		public function onLoader(x:XML):void
		{
			this.xml=x;
			this.sumLoad=xml.child("media").length();
			if (this.sumLoad == 0)
			{
				this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
				return;
			}			
			loopLoad();			
		}	
		/**
		 * 循环加载
		 * @param xml
		 */
		private function loopLoad():void
		{
			super.extendOnLoaderURL(xml.media[this.loadCount].@src,ExtendLoader.MEL_LOADERINFO);
		}
		/**
		 * 重写父类加载完成
		 * @param e
		 */
		override protected function onLoadByteComplete(e:Event):void
		{
			if(this.loopError)					
				return;		
			LoaderArr.push(this.getLoader());
			byteVOArr.push(this.getByte());		
			this.loadCount++;			
			try
			{
				if (this.sumLoad==this.loadCount)
				{
					materialVO.xml=xml;
					materialVO.LoaderArr=LoaderArr;
					materialVO.byteVOArr=byteVOArr;
					this.dispatchEvent(e);
				}	
				else
				{
					loopLoad();
				}				
			}catch(er:Error)
			{
				this.loopError=true;			
				super.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));			
			}				
		}
		/**
		 * 重写父类加载错误
		 * @param e
		 */
		override protected function onIoError(e:IOErrorEvent):void
		{
			if(!this.loopError)
				this.dispatchEvent(e);
			this.loopError=true;		
		}	
		/**
		 * 清理垃圾
		 */
		override public function clear():void
		{
			LoaderArr=null;
			byteVOArr=null;
			xml=null;
			materialVO=null;
			sumLoad=0;
			loopError=false;
			loadCount=0;
			super.clear();
		}
		/**
		 * 返回材质对象
		 * @return
		 */
		public function getMaterialVO():MaterialVO
		{
			return materialVO;
		}

	}
}