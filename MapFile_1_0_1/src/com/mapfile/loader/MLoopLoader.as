package com.mapfile.loader
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	
	/**
	 * 该类用于循环加载一个url集合地址,并返回一个LoaderInfo集合
	 * @author 王明凡
	 */
	public class MLoopLoader extends MLoader
	{
		//swf的字节数组长度集合
		private var SWFLengthArr:Array;
		//swf的字节数组
		private var SWFByte:ByteArray;
		//swf的Loader对象集合
		private var SWFLoaderArr:Array;		
		//循环加载个数
		private var loopCount:int;
		//循环加载错误
		private var loopError:Boolean=false;	
		//swf的字节数组集合
		private var SWFByteArr:Array;
		
		public function MLoopLoader()
		{
			SWFLoaderArr=new Array();
			SWFByteArr=new Array();
		}
		/**
		 * 开始循环加载
		 * @param URLArr
		 */
		public function onLoopLoader(SWFLengthArr:Array,SWFByte:ByteArray):void
		{
			this.SWFLengthArr=SWFLengthArr;
			this.SWFByte=SWFByte;
			loopLoad();
		}	
		/**
		 * 进行循环加载
		 */
		protected function loopLoad():void
		{
			var tmp:ByteArray=new ByteArray();
			SWFByte.readBytes(tmp,0,int(SWFLengthArr[loopCount]));
			SWFByteArr.push(tmp);
			super.onLoaderByte(tmp);
			tmp=null;
		}
		/**
		 * 重写父类onLoaderURL()加载完成
		 * @param e
		 */
		override protected function onLoadByteComplete(e:Event):void
		{
			if(loopError)					
				return;		
			SWFLoaderArr.push(this.getLoader());		
			if((loopCount+1)==SWFLengthArr.length)
			{
				this.dispatchEvent(e);
			}
			else
			{
				loopCount++;
				loopLoad();
			}
		}
		/**
		 * 重写父类加载错误
		 * @param e
		 */
		override protected function onIoError(e:IOErrorEvent):void
		{
			if(!loopError)
				this.dispatchEvent(e);
			this.loopError=true;			
		}		
		/**
		 * 返回材质loader对象集合
		 * @return 
		 */
		public function getSWFLoaderArr():Array
		{
			return SWFLoaderArr;
		}
		/**
		 * 返回swf的字节数组集合
		 * @return 
		 */
		public function getSWFByteArr():Array
		{
			return SWFByteArr;
		}
		/**
		 * 重写父类垃圾清理
		 */
		override public function clear():void
		{
			if(SWFLengthArr)
				SWFLengthArr.splice(0,SWFLengthArr.length);
			SWFLengthArr=null;
			if(SWFByte)
				SWFByte.clear();
			SWFByte=null;
			SWFLoaderArr=null;
			SWFByteArr=null;
			loopCount=0;
			super.clear();
		}			
	}
}