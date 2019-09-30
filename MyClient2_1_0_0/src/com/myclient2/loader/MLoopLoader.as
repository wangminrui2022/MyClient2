/**
 * copyright © 2010 王明凡,MyClient2引擎著作权受到法律和国际公约保护
 * 使用MyClient2引擎之前必须签订"MyClient2产品-授权协议"，以及遵守"MyClient2产品-授权协议"才能使用
 * */
package com.myclient2.loader
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
	/**
	 * MLoopLoader循环加载，使用递归方式循环加载材质字节数组
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
				
		/**
		 * 构造函数
		 */
		public function MLoopLoader()
		{
			SWFLoaderArr=new Array();	
		}
		
		/**
		 * 根据字"节游标长度数组"和"字节数组"开始循环加载
		 * @param SWFLengthArr	节游标长度数组
		 * @param SWFByte		字节数组
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
			super.onLoaderByte(tmp);
			tmp=null;
		}
		/**
		 * 重写父类URL加载方式加载完成
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
		 * 返回材质Loader对象集合
		 * @return 
		 */
		public function getSWFLoaderArr():Array
		{
			return SWFLoaderArr;
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
			loopCount=0;
			super.clear();
		}													
	}
}