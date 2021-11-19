1. command+s
   template/app_doc/editor/modify_doc.html:342+
   ```
        // macos command +s for firefox and chrome
        var isCtrl = false;
        document.onkeyup=function(e){
            if(e.which == 224||e.which == 91) isCtrl=false;
        }
        document.onkeydown=function(e){
            if(e.which == 224||e.which == 91) isCtrl=true;
            if(e.which == 83 && isCtrl == true) {
                modifyDoc();
                return false;
            }
        }
   ```

2. toc height
   
   static/toc/doctoc.js:217
   ```
        max-height:700px;
   ```

3. 取消标题折叠
   static/mrdoc/mrdoc-docs.js:250+
   ```
       $(".layui-icon-left").length>=1?($(".switch-toc")).toArray().forEach(function(ele){ele.click(SwitchToc)}):'';
   ```