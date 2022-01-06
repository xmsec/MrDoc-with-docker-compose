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
       $(".layui-icon-down").length<1?($(".switch-toc")).toArray().forEach(function(ele){ele.click(SwitchToc)}):'';
    ```

4. 修复pdf导出后部分情况下图片渲染失败问题, epub导出仍存在问题, 目前无法定位
    app_doc/report_utils.py:800+
    ```           
    self.content_str = re.sub("(!\[[^](]*?\])\(\/media\/","\\1(../../media/",self.content_str)
    ```
    **补充:**    
    此环境下添加PDF导出功能可通过该方法搭建环境: (via : [参考链接](https://ubuntuhandbook.org/index.php/2021/05/install-chromium-browser-ppa-ubuntu-20-04/))
    ```
    apt install -y software-properties-common
    add-apt-repository ppa:xtradeb/apps
    apt install chromium
    apt-get install ttf-wqy*
    ```
    从 https://npm.taobao.org/mirrors/chromedriver/ 选择与 chromium --version 版本配对的 driver, 然后 
    ```
    unzip chromedriver.zip
    cp chromedriver /usr/lib/chromium/chromedriver
    ``` 
 
5. 增加TOC列表一级目录默认排序次选项: 文档标题. 文档按照排序值/文档名称依次排序
    app_doc/views.py:119
    ```
    top_docs = Doc.objects.filter(top_doc=pro_id, parent_doc=0, status=1).values('id', 'name','open_children','editor_mode').order_by('sort','name')
    ```