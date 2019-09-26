package com.controller.business
{
	import com.vo.FileVO;
	
	import flash.filesystem.*;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 大文件操作(读取)
	 * 
	 *  var fVO:FileVO=new FileVO();
	 *  fVO.file=file;
	 *  this.sendNotification(FileCommand.FILE, fVO, "1/2/3/4/5/6/7");
	 * 
	 * @author wangmingfan
	 */
	public class FileCommand extends SimpleCommand
	{
		//(通知)
		public static const FILE:String="file";
		//(通知)
		public static const FILE_RESULT:String="file_result";
		//(通知)
		public static const FILE_ERROR:String="file_error";
		
		//指定缓存大小
		private var size:int;
		//总共大小
		private var totalSize:Number=0;
		//总页数
		private var pageSum:Number=0;
		//当前页数
		private var pageNow:Number=1;
		//读取字节数组
		private var readByte:ByteArray;
		//读写类型
		private var type:String;
		//
		private var fVO:FileVO;

		public function FileCommand()
		{
			super();
		}

		/**
		 * type	(区别那个业务在使用)
		 * @param note
		 */
		override public function execute(note:INotification):void
		{
			try
			{
				type=note.getType();
				fVO=note.getBody() as FileVO;
				if (fVO.workType == "read")
					readFile(fVO.file, fVO.size);
				else
					writeFile(fVO.file, fVO.byte, fVO.size);
			}
			catch (er:Error)
			{
				this.sendNotification(ExceptionCommand.EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}

		/**
		 * 读取文件
		 * @param file		文件
		 * @param size		指定缓冲区的大小
		 */
		private function readFile(file:File, size:int):void
		{
			this.size=size;
			this.readByte=new ByteArray();
			var stream:FileStream=new FileStream();
			try
			{

				stream.open(file, FileMode.UPDATE);
				if (stream.bytesAvailable > size)
				{
					totalSize=stream.bytesAvailable;
					pageSum=getpageSum();
					for (var i:int=(pageNow - 1) * size; i < pageSum; i++)
					{
						//如果是最后一页
						if (stream.bytesAvailable < size)
							stream.readBytes(readByte, i * size, stream.bytesAvailable);
						else
							stream.readBytes(readByte, i * size, size);
					}				
				}
				else
				{
					stream.readBytes(readByte, 0, stream.bytesAvailable);
				}
			}
			catch (er:Error)
			{
				clearFileStream(stream);
				stream=null;
				file=null;
				this.sendNotification(FILE_ERROR, null, type);
				clear();
				return;
			}
			onComplete(stream);
			stream=null;
			file=null;
		}
			
		/**
		 * 写入文件
		 * @param f
		 * @param byte
		 * @param size
		 */
		public function writeFile(file:File, byte:ByteArray, size:int,delay:Number=40):void
		{
			this.size=size;
			var stream:FileStream=new FileStream();
			try
			{
				stream.open(file, FileMode.WRITE);
				if (byte.length > size)
				{
					totalSize=byte.length;
					pageSum=getpageSum();
					for (var i:int=(pageNow - 1) * size; i < pageSum; i++)
					{
						//如果是最后一页
						if (totalSize - stream.position < size)
							stream.writeBytes(byte, i * size, totalSize - stream.position);
						else
							stream.writeBytes(byte, i * size, size);
					}
				}
				else
				{
					stream.writeBytes(byte, 0, byte.length);
				}
			}
			catch (er:Error)
			{
				byte.clear();
				byte=null;
				file=null;
				clearFileStream(stream);
				this.sendNotification(FILE_ERROR, null, type);
				return;
			}
			byte.clear();
			byte=null;
			file=null;				
			onComplete(stream);	
		}
		/**
		 * 文件完成
		 * @param stream
		 */
		private function onComplete(stream:FileStream):void
		{
			clearFileStream(stream);
			stream=null;
			if (fVO.workType== "read")
				this.sendNotification(FILE_RESULT, getReadByte(), type);
			else
				this.sendNotification(FILE_RESULT, null, type);
			clear();
		}

		/**
		 *  垃圾清理FileStream
		 * @param stream
		 */
		public function clearFileStream(stream:FileStream):void
		{
			try
			{
				stream.close();
				stream=null;
			}
			catch (er:Error)
			{
				this.sendNotification(ExceptionCommand.EXCEPTION, er.message + "\n" + er.getStackTrace());
			}
		}

		/**
		 * 垃圾清理
		 */
		public function clear():void
		{
			readByte=null;
			size=0;
			totalSize=0;
			pageSum=0;
			pageNow=1;
			type=null;
			fVO.file=null;
			fVO=null;
		}

		/**
		 * 获得总页数
		 */
		private function getpageSum():Number
		{
			if (totalSize % size == 0)
				return totalSize / size;
			else
				return Math.round(totalSize / size) + 1;
		}

		/**
		 * 获得读取的字节数组
		 * @return
		 */
		public function getReadByte():ByteArray
		{
			return readByte;
		}
	}
}