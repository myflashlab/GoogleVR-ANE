package com.myflashlab.template.mobile.starling 
{
	import feathers.controls.TextInput;
	import feathers.core.ITextEditor;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 3/10/2014 2:14 PM
	 */
	public class ExposedTextInput extends TextInput 
	{
		
		public function ExposedTextInput() 
		{
			super();
			this.textEditorFactory = function():ITextEditor 
			{
				return new ExposedStageTextTextEditor();
			}
		}
		
		public function get nativeStageText():Object
		{
			return ExposedStageTextTextEditor(this.textEditor).nativeStageText;
		}
		
	}

}