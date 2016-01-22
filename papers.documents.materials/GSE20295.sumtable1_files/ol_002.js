(function(a){a.widget("ol.reportScreen",{options:{reportType:"special_report",reportTypeTrigger:false,reportNameURL:"",reportNameUIURL:"",addReportURL:"",getReportsURL:"",deleteReportURL:""},vars:{reportHTML:"",$ajaxLoader:""},_create:function(){var b=this,d=b.options,c=b.element;
this._createReportTypes()
},_getExternalID:function(){var b=a("#externalID").val(),c=new RegExp("#","g");
if(b){b=b.replace(c,"%23")
}return b
},_getContext:function(){var b=location.protocol+"//"+location.host;
return b
},_getReportGridHTML:function(){var b=this,c;
c+=' <div id="report_queue">';
c+='     <div id="dialog" title="Generate Report">';
c+='         <span id="message"></span>';
c+="     </div>";
c+='     <div class="refresh">';
c+='         <div style="float:left;">';
c+='             <a href="#" id="show_reports"><img src="/images/down_arrow.png" title="Expand Report Section" class="expand"></a> Report Queue';
c+="         </div>";
c+='         <div align="right">';
c+='             <a href="#" id="refresh_reports" alt="Refresh Report Queue" title="Refresh Report Queue"><img src="/images/refresh.png" title="Refresh"></a>';
c+="         </div>";
c+="     </div>";
c+='     <div class="ajax-loader">';
c+='         <img src="/images/ajax-loader.gif" alt="Loading ...">';
c+="     </div>";
c+='     <table border="0" cellpadding="5" cellspacing="2" class="report" id="report_list">';
c+="         <thead>";
c+='             <tr class="stripe">';
c+="                 <th><b>Report Type</b></th>";
c+="                 <th><b>Report Name</b></th>";
c+="                 <th><b>Start Date</b></th>";
c+="                 <th><b>End Date</b></th>";
c+="                 <th><b>Status</b></th>";
c+='                 <th colspan="2" rowspan="1"><b>Actions</b></th>';
c+="             </tr>";
c+="         </thead>";
c+="     </table>";
c+=" </div>";
return c
},_buildReportGrid:function(){var b=this,c=b.element,d=b._getReportGridHTML();
a(d).appendTo(c);
$ajaxLoader=a(".ajax-loader");
c.delegate("#refresh_reports, #show_reports","click",function(f){b._refreshReports(f)
})
},_createReportForm:function(){var b=this,d=b.options,c=b.element,e;
e+='<form action = "'+b.addReportURL+'" class="simple report_form" id="generateReports" method="post">';
e+="<fieldset></fieldset>";
e+="</form>";
c.children().wrapAll(e)
},_deleteReport:function(i){i.preventDefault();
$ajaxLoader.show();
var l=this,d=l.options,h=l.element,b=l._getContext(),j=a(i.target).parent("a"),c=j.attr("id"),g=j.attr("data-cust"),f=l._getExternalID(),k="";
if(f){k="&externalID="+f
}a.ajax({url:b+"/"+d.deleteReportURL,data:"id="+c+"&custid="+g+""+k,type:"get",cache:false,success:function(e){if(e==="Success"){$ajaxLoader.hide();
j.parent("td").parent("tr").fadeOut(500)
}}})
},_showReports:function(){var d=this,f=d.options,e=d.element,h=this._getContext(),c=d._getExternalID(),g=e.find("form").serialize();
var b=(f.reportType==="ol_access_report")?h:h+"/admin-tools-web";
a.ajax({url:h+"/"+f.getReportsURL,type:"get",data:g,cache:false,success:function(u){a("#report_list tbody").remove();
var n=JSON.parse(u);
var C="";
for(var D in n){var z=n[D].id,w=n[D].displayReportType,H=n[D].displayReportName,G=n[D].startMonth,A=n[D].startYear,B=n[D].endMonth,r=n[D].endYear,v=n[D].startDate,m=n[D].endDate,q=n[D].displayReportStatus,o=n[D].downloadUrlfortsv,F=n[D].downloadUrlforcsv,y=n[D].downloadUrlforxml,l=n[D].downloadUrlforxlsx,x=n[D].reportCustID,j="",t='<img src="/images/bin.png" title="Delete" />',s="",p="";
var k=G+"/"+v+"/"+A,E=B+"/"+m+"/"+r;
if(q==="Error-Please Try Again"){p='class="errRow"'
}if(q==="Error-Please Try Again"||q==="Completed"){t='<a href="#" id="'+z+'" data-cust="'+x+'" class="delete">'+t+"</a>"
}if(c){s="&externalID="+c
}if(H==="COUNTER Consortium Report 1"){j=(q==="Completed")?'<a href="'+b+""+y+""+s+'">XML</a>':"XML"
}else{if(H.indexOf("COUNTER")>-1||H==="Journal's Frontfile Report"){j=(q==="Completed")?'<a href="'+b+""+l+""+s+'">XLSX</a> | <a href="'+b+""+o+""+s+'">TSV</a> | <a href="'+b+""+y+""+s+'">XML</a>':"XLSX | TSV | XML"
}else{if(H==="Database Report 1"||H==="Database Report 2"||H==="Platform Report 1"){j=(q==="Completed")?'<a href="'+b+""+l+""+s+'">XLSX</a> | <a href="'+b+""+o+""+s+'">TSV</a> | <a href="'+b+""+y+""+s+'">XML</a>':"XLSX | TSV | XML"
}else{if(H==="journalsAccessReport"||H==="books_MRWs_AccessReport"||H==="databases_LabprotocolsAccessReport"){w=w.replace("?","'");
k="Not Applicable";
E="Not Applicable";
H="Customer Access Report";
j=(q==="Completed")?'<a href="'+b+""+l+""+s+'">XLSX</a> | <a href="'+b+""+F+""+s+'">CSV</a>':"XLSX | CSV"
}else{j=(q==="Completed")?'<a href="'+b+""+l+""+s+'">XLSX</a> | <a href="'+b+""+F+""+s+'">CSV</a>':"XLSX | CSV"
}}}}C+="<tr "+p+"><td>"+w+"</td><td>"+H+"</td><td>"+k+"</td><td>"+E+"</td><td>"+q+"</td><td>"+j+"</td><td>"+t+"</td></tr>"
}a("#report_list").append(C);
$ajaxLoader.hide();
e.find("#report_list").delegate("a.delete","click",function(i){d._deleteReport(i)
})
}})
},_buildReportButton:function(){var b=this;
this.vars.reportHTML+='<input type="submit" value="Generate" class="submit generatebtn" />';
a(this.vars.reportHTML).appendTo(this.element);
this._buildUIActions();
this._createReportForm();
if(a("#report_queue").length<1){b._buildReportGrid()
}},_addReport:function(h){h.preventDefault();
var b=this,d=b.options,c=b.element,j=this._getContext(),g=c.find("form").serialize(),f=a("#report_type option:selected").text(),i;
a.ajax({url:j+"/"+d.addReportURL,type:"GET",data:g,cache:false,success:function(e){var k=c.find(".report_error_msg");
if(k){k.remove()
}switch(e){case"Success":alert("Report added to queue");
break;
case"exists":alert("Report is currently in queue");
break;
case"failure":alert("Error-Please Try Again");
break;
case"invalidLicense":i="This customer does not have active licenses for "+f;
c.find("fieldset").append('<p class="report_error_msg">'+i+"</p>");
return;
break;
default:}if(e!==""){b._showReports();
a("table.report").slideDown(300)
}}})
},_buildReportTypeUI:function(g){var b=this,f=b.element,d=b.options,h=this._getContext(),c=a("#report_type").val();
a.ajax({url:h+"/"+d.reportNameUIURL,type:"GET",data:"reportType="+c,cache:false,success:function(e){var i='<div class="report-sub-block">'+e+"</div>";
if(a(".report-sub-block").length<1){a(g.target).parents(".report_type_block").after(i)
}else{a(".report-sub-block").html(e)
}}})
},_refreshReports:function(d){d.preventDefault();
var b=this,c=a(d.target).attr("class");
a(".ajax-loader").show();
a("#report_list tbody").remove();
b._showReports();
if(c==="expand"){a("table.report").slideToggle(300)
}else{a("table.report").slideDown(300)
}},_isLeapYear:function(c){var b=false;
c=parseInt(c,10);
if(((c%4===0)&&!(c%100===0))||(c%400===0)){b=true
}else{b=false
}return b
},_validateDate:function(g,f,e){var c=this,b=[1,3,5,7,8,10,12,1,3,5,7,8,"January","March","May","July","August","October","December","JAN","MAR","MAY","JUL","AUG","OCT","DEC"],d=true;
if(g==="02"||g==="2"||g==="FEB"||g==="February"){e=parseInt(e,10);
if(e<=28||(e===29&&c._isLeapYear(f))){d=true
}else{d=false
}}else{if(a.inArray(parseInt(g,10),b)===-1){if(parseInt(e,10)>30){d=false
}}}return d
},_setError:function(b){if(b!==""){if(a(".report_error_msg").length>0){a(".report_error_msg").html(b)
}else{this.element.find("fieldset").append('<p class="report_error_msg">'+b+"</p>")
}}else{a(".report_error_msg").remove()
}},_validateEmptyArr:function(b){var c=true;
a.each(b,function(d,e){if(e===""){c=false
}});
return c
},_validReport:function(){var q=this,c=q.options,n=true,i=q.element,b=a("#report_type"),g;
if(c.reportType==="special_report"){var l=a(".reportMonthStart").val(),o=a(".reportDayStart").val(),f=a(".reportYearStart").val(),e=a(".reportMonthEnd").val(),r=a(".reportDayEnd").val(),h=a(".reportYearEnd").val(),k=[l,o,f,e,r,h];
if(!q._validateEmptyArr(k)){n=false;
q._setError("Required Field")
}else{var d=new Date(f,l-1,o),j=new Date(h,e-1,r),m=j-d,p=m/1000/60/60/24;
if(d>j){n=false;
q._setError("End date must be greater than Start date")
}else{if(p>=365){if(p===365&&(q._isLeapYear(f)||q._isLeapYear(h))){n=n
}else{n=false;
q._setError("Invalid date range")
}}else{if(!q._validateDate(l,f,o)){n=false;
q._setError("Invalid start date")
}else{if(!q._validateDate(e,h,r)){n=false;
q._setError("Invalid end date")
}else{q._setError("")
}}}}}}return n
},_buildUIActions:function(){var c=this,d=c.options,b=a("#report_type");
if(d.reportTypeTrigger){b.change(function(f){c._buildReportTypeUI(f)
});
b.trigger("change")
}this.element.delegate("#generateReports","submit",function(f){if(c._validReport()){c._addReport(f)
}f.preventDefault()
})
},_createReportTypes:function(){var b=this,c=b.element;
opt=b.options,curURL=this._getContext(),vars=this.vars;
a.ajax({url:curURL+"/"+opt.reportNameURL,data:"",type:"GET",error:function(d){alert("Something went wrong !! Please try again after sometime")
},success:function(d){var e=c.attr("id");
if(e){vars.reportHTML+='<input type="hidden" name="externalID" id="externalID" value="'+c.attr("id")+'"/>'
}if(opt.reportType==="special_report"){vars.reportHTML+='<div class="report_type_block report_type_block--special"> '+decodeURIComponent(d)+" </div>"
}else{vars.reportHTML+='<div class="report_type_block"> '+decodeURIComponent(d)+" </div>"
}b._buildReportButton()
}})
}})
})(jQuery);