# -*- coding: UTF-8 -*-

module Head

Template = %q{
本次调整的有条件建设区共<%= downtown.all_input_count %>个地块，总面积<%=downtown.all_input_area%>公顷。其中涉及<%= downtown.wujing.name %><%=downtown.wujing.input_land_length %>个地块<%=downtown.wujing.input_project_length %>个项目，总面积<%=downtown.wujing.input_area %>公顷；其中涉及<%= downtown.xinbei.name %><%=downtown.xinbei.input_land_length %>个地块<%=downtown.xinbei.input_project_length %>个项目，总面积<%=downtown.xinbei.output_area %>公顷。
}

Template1 = %q{

<%= downtown.wujing.name %><%= downtown.wujing.input.name %>涉及项目包括<%= downtown.wujing.input.projects.inject(""){|sum,x| sum + x.name + "、"}[0..-2]%>。地块具体信息如下：

<% downtown.wujing.input.projects.each do |p| %>
<%= p.name %>，坐落在<%= p.local %>，项目涉及地块<%= p.lands.inject(""){|sum,x| sum + x.num + "、"}[0..-2] %>共<%= p.lands.length %>个地块。其中<% p.lands.each do |l| %> <%= l.num %>位于<%= l.local %>，拟调整面积<%= sprintf("%0.4f",l.area) %>公顷，其中占用农用地面积<%= sprintf("%0.4f",l.area_nongyongdi) %>公顷、耕地<%= sprintf("%0.4f",l.area_gengdi)  %>公顷，未利用地<%= sprintf("%0.4f",l.area_weiliyongdi) %>公顷，现状为农用地，占用建设用地<%= sprintf("%0.4f",l.area_jiansheyongdi) %>公顷，现状为建设用地；<% end %>共计拟调整面积<%= sprintf("%0.4f",p.area) %>公顷，其中农用地<%= sprintf("%0.4f",p.area_nongyongdi) %>公顷，耕地<%= sprintf("%0.4f",p.area_gengdi) %>公顷。
<% end %>

}

Template2 = %q{
本次调整的有条件建设区共<%= downtown.all_output_count %>个地块，总面积<%=downtown.all_output_area%>公顷。其中涉及<%= downtown.wujing.name %><%=downtown.wujing.output_land_length %>个地块，总面积<%=downtown.wujing.output_area %>公顷；其中涉及<%= downtown.xinbei.name %><%=downtown.xinbei.output_land_length %>个地块，总面积<%=downtown.xinbei.output_area %>公顷。
}

Template3 = %q{
<%= downtown.wujing.name %><%= downtown.wujing.output.name %>地块具体信息：<% downtown.wujing.output.get_all_out_land do |l| %><%=l.num %>号地块，位于<%= l.local %>，拟调整面积<%= sprintf("%0.4f",l.area) %>公顷，其中占用农用地<%= sprintf("%0.4f",l.area_nongyongdi) %>公顷、耕地<%= sprintf("%0.4f",l.area_gengdi) %>公顷，未利用地<%= sprintf("%0.4f",l.area_weiliyongdi) %>公顷，调整前用途为建设用地。<% end %>
}
end
