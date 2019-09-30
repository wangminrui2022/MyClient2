/**
 * MyClient2地图编辑器 - Copyright (c) 2010 王明凡
 */
package com.pureMVC.controller.business.map
{
	import com.consts.MString;
	import com.consts.Msg;
	import com.map.Objects;
	import com.pureMVC.controller.business.bindable.SaveStateUpdateCommand;
	import com.pureMVC.controller.business.common.Message2Command;
	import com.pureMVC.model.MapProxy;
	import com.pureMVC.model.MaterialProxy;
	import com.pureMVC.view.ui.as_.OnlyImage;
	import com.vo.common.MessageAlert2VO;
	import com.vo.material.MaterialTileVO;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.ContextMenuEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 获得拖动场景对象(objects)
	 * @author 王明凡
	 */
	public class GetDragObjectsCommand extends SimpleCommand
	{
		
		public static const GDOC_GET_DRAG_OBJECTS:String="gdoc_get_drag_objects";
		
		public static const GDOC_GET_DRAG_OBJECTS_RESULT:String="gdoc_get_drag_objects_result";

		private var mapP:MapProxy;
		
		private var materialP:MaterialProxy;
				
		public function GetDragObjectsCommand()
		{
			mapP=this.facade.retrieveProxy(MapProxy.NAME) as MapProxy;
			materialP=this.facade.retrieveProxy(MaterialProxy.NAME) as MaterialProxy;
		}
		
		override public function execute(note:INotification):void
		{
			var mTileVO:MaterialTileVO;
			if(note.getBody() is ContextMenuEvent)
				mTileVO=materialP.getOnlyImage(note.getBody() as ContextMenuEvent).mTileVO;
			else
				mTileVO=note.getBody() as MaterialTileVO;
				
			var oj:Objects;
			if (mTileVO.mdVO.type == MString.OBJECT)
			{
				if(mTileVO.mdVO.used==MString.NULL || mTileVO.mdVO.used==MString.OPERATE)
				{
					if (!mTileVO.roadArr)
						sendMessage2(Msg.Msg_10);
					else if(mTileVO.roadArr.length==0)
						sendMessage2(Msg.Msg_10);
					else
						oj=getObjects(mTileVO);				
				}
				else
				{
					mTileVO=null;
					mapP=null;
					sendMessage2(Msg.Msg_9_1);
					return;					
				}
			}
			else if(mTileVO.mdVO.type == MString.TILE)
			{
				if (mTileVO.mdVO.used == MString.ONLY || mTileVO.mdVO.used==MString.OPERATE)
				{
					oj=getObjects(mTileVO);
				}
				else if (mTileVO.mdVO.used == MString.TILES)
				{
					mapP.tiles.clear();
					var data:BitmapData
					if(mTileVO.mdVO.elementType==MString.MOVIECLIP)
					{
						var tmpMC:MovieClip=new mTileVO.mClass() as MovieClip;
						data=new BitmapData(tmpMC.width,tmpMC.height,true,0);
						data.draw(tmpMC);
						tmpMC=null;
					}
					else
					{
						data=new mTileVO.mClass(null,null) as BitmapData;
					}
					mapP.tiles.onTiles(
					mapP.map.info.mapType,
					data,
					mapP.map.info.row,
					mapP.map.info.column,
					mapP.map.info.tileHeight);
					data=null;
					mapP.map.info.diffuse=mTileVO.mdVO.diffuse;	
					//更新编辑状态和标题栏
					this.sendNotification(SaveStateUpdateCommand.SSUC_SAVE_STATE_UPDATE,true);			
				}
				else
				{
					mTileVO=null;
					mapP=null;
					sendMessage2(Msg.Msg_9_2);
					return;					
				}				
			}
			else
			{
				mTileVO=null;
				mapP=null;
				sendMessage2(Msg.Msg_9);
				return;
			}
			this.sendNotification(GDOC_GET_DRAG_OBJECTS_RESULT,oj);	
			mTileVO=null;
			oj=null
			mapP=null;
			materialP=null;
		}	
		/**
		 * 显示Message2
		 * @param msg
		 */
		private function sendMessage2(msg:String):void
		{
			var msgVO:MessageAlert2VO=new MessageAlert2VO();
			msgVO.msg=msg;
			this.sendNotification(Message2Command.MC2_MESSAGE, msgVO);
			msgVO=null;
		}
		/**
		 * 获得场景对象
		 * @param mTileVO
		 * @return
		 */
		private function getObjects(mTileVO:MaterialTileVO):Objects
		{
			var oj:Objects=new Objects(mTileVO, ++mapP.map.objectIndex);
			oj.extendsDraws(mapP.map.info.tileHeight);
			mTileVO=null;
			return oj;
		}					
	}
}