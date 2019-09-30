package com.roleobject.loader
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	/**
	 * 角色材质加载
	 * @author 王明凡
	 */
	public class RoleMaterialLoader extends ExtendLoader
	{
		private var loaderArr:Array;	
		
		private var  mediaArr:Array;
		//循环加载个数
		private var loopCount:int;
		//循环加载错误
		private var loopError:Boolean=false;	
				
		public function RoleMaterialLoader()
		{
			loaderArr=new Array();
		}
		public function onRoleMaterialLoader(mediaArr:Array):void
		{
			this.mediaArr=mediaArr;
			loopLoad();
		}
		public function loopLoad():void
		{
			super.extendOnLoaderURL(mediaArr[loopCount],MEL_LOADERINFO);
		}
		override protected function onLoadByteComplete(e:Event):void
		{
			if(loopError)					
				return;		
			loaderArr.push(this.getLoader());		
			if((loopCount+1)==mediaArr.length)
			{
				this.dispatchEvent(e);
			}
			else
			{
				loopCount++;
				loopLoad();
			}
		}
		override protected function onIoError(e:IOErrorEvent):void
		{
			if(!loopError)
				this.dispatchEvent(e);
			this.loopError=true;			
		}	
		public function getLoaderArr():Array
		{
			return loaderArr;
		}	
		override public function clear():void
		{
			loaderArr=null;
			mediaArr=null;
			loopCount=0;
			super.clear();
		}						
	}
}