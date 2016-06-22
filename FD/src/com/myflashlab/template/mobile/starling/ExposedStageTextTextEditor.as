package com.myflashlab.template.mobile.starling 
{
	import feathers.controls.text.StageTextTextEditor;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 3/10/2014 2:14 PM
	 */
	public class ExposedStageTextTextEditor extends StageTextTextEditor 
	{
		
		public function ExposedStageTextTextEditor() 
		{
			super();
		}
		
		public function get nativeStageText():Object
		{
			return this.stageText;
		}
		
	}

}