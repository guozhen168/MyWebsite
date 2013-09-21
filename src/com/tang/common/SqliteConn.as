package com.tang.common
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.MovieClip;
	import flash.errors.SQLError;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	
	public class SqliteConn extends MovieClip
	{
		private var conn:SQLConnection;
		private var selectData:SQLStatement = new SQLStatement();
		
		public function SqliteConn() {
			conn = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, openHandler);
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			var dbFile:File = File.applicationDirectory.resolvePath("MyWebsite.db");
			conn.open(dbFile)
		}
		
		private function openHandler(event:SQLEvent):void
		{
			trace("the database was opened successfully");
			
		}
		
		public function createQuery(sql:String):SQLStatement {
			var stmt:SQLStatement = new SQLStatement(); 
			stmt.sqlConnection = conn;
			stmt.text = sql;
			return stmt;
		}
		
		public function selece(sql:String, listener:Function):void {
			selectData = new SQLStatement(); 
			selectData.sqlConnection = conn;
			selectData.text = sql;
			selectData.addEventListener(SQLEvent.RESULT, listener != null ? resultHandler : listener); 
			selectData.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			//trace("selectdata "+selectData.execute())
			try {
				selectData.execute();
			} catch (error:SQLError) 
			{ 
				trace(error);
			}
		}
		private function resultHandler(event:SQLEvent):void 
		{ 
			var result:SQLResult = event.target.getResult();
			if (result != null) {
				var numResults:int = result.data.length;
				Alert.show("记录数：" + numResults);
			}
		} 
		
		public function errorHandler(event:SQLErrorEvent):void
		{
			//trace("Error code:", event.error.code);
			Alert.show(event.error.message, "错误提示");
		}
		
	}
}