package modules.chart
{
	public class ColumnChartXml
	{
		public function ColumnChartXml()
		{
		}
		public static var product1XML:XML = 
			<anychart>
				<!--图的边距-->
				<margin all="0"/>
				<charts>
				  <chart plot_type="CategorizedVertical">
 					 <data_plot_settings default_series_type="bar" enable_3d_mode="false" z_aspect="0.5">
					   <bar_series point_padding="0" group_padding="1">
						   <label_settings enabled="true">
							   <font bold="true" size="14" />
								<format><![CDATA[{%Value}{numDecimals:0}]]></format>
						   </label_settings>
						   <tooltip_settings enabled="true">
							   <font bold="true" />
							   <format><![CDATA[{%Value}{numDecimals:0}]]></format>
						   </tooltip_settings>
					   </bar_series>
				   </data_plot_settings>
					<chart_settings>
					  <title>
						<text>产品档案-使用年限统计</text>
					  </title>
					  <!--坐标轴定义-->
					  <axes>
						<x_axis>
						  <title enabled="false"/>
						  <labels>
							<font bold="true"/>
						  </labels>
						  <!--设置轴位置-->
						  <scale  /> 
						</x_axis>
						<y_axis>
						  <title enabled="true">
							<text>产品数量(件\台\个)</text>
						  </title>
						  <labels>
							<font bold="true"/>
							<format><![CDATA[{%Value}{numDecimals:0} ]]></format>
						  </labels>
						  <scale minimum="0"  /> 
						  <major_grid>
							<interlaced_fills>
							  <even>
								<fill color="Rgb(230,230,230)"/>
							  </even>
							</interlaced_fills>
						  </major_grid>
						</y_axis>
					  </axes>
					  <!--坐标轴定义 end-->
					</chart_settings>
					<data>
					  #DATA#
					</data>
				  </chart>
				</charts>
			  </anychart>;
		
		public static var product2XML:XML = 
			<anychart>
				<!--图的边距-->
				<margin all="0"/>
				<charts>
				  <chart plot_type="CategorizedVertical">
					 <data_plot_settings default_series_type="bar" enable_3d_mode="false" z_aspect="0.5">
					   <bar_series point_padding="0" group_padding="1">
						   <label_settings enabled="true">
							   <font bold="true" size="14" />
								<format><![CDATA[{%Value}{numDecimals:0}]]></format>
						   </label_settings>
						   <tooltip_settings enabled="true">
							   <font bold="true" />
							   <format><![CDATA[{%Value}{numDecimals:0}]]></format>
						   </tooltip_settings>
					   </bar_series>
				   </data_plot_settings>
					<chart_settings>
					  <title>
						<text>产品档案-采购价格统计</text>
					  </title>
					  <!--坐标轴定义-->
					  <axes>
						<x_axis>
						  <title enabled="false"/>
						  <labels>
							<font bold="true"/>
						  </labels>
						  <!--设置轴位置-->
						  <scale  /> 
						</x_axis>
						<y_axis>
						  <title enabled="true">
							<text>产品数量(件\台\个)</text>
						  </title>
						  <labels>
							<font bold="true"/>
							<format><![CDATA[{%Value}{numDecimals:0} ]]></format>
						  </labels>
						  <scale minimum="0"  /> 
						  <major_grid>
							<interlaced_fills>
							  <even>
								<fill color="Rgb(230,230,230)"/>
							  </even>
							</interlaced_fills>
						  </major_grid>
						</y_axis>
					  </axes>
					  <!--坐标轴定义 end-->
					</chart_settings>
					<data>
					  #DATA#
					</data>
				  </chart>
				</charts>
			  </anychart>;
	}
}