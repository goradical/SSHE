<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript">
  $(function () {
    $('#admin_usermanager_datagrid').datagrid({
      url: '${pageContext.request.contextPath}/userAction!datagrid',
      fit: true,
      border: false,
      pagination: true,
      fitColumns: true,
      rownumbers: true,
      idField: 'id',
      sortName: 'name',
      sortOrder: 'asc',
      checkOnSelect: false,
      selectOnCheck: true,
      frozenColumns: [[
        {title: '编号', field: 'id', checkbox: true, width: 150},
        {title: '名称', field: 'name', width: 150, sortable: true}
      ]],
      columns: [[{
        title: '密码', field: 'pwd', width: 50,
        formatter: function (value, row, index) {
//        return '<span title="' + row.name + ':' + value + '">' + value + '</span>';
          return '***********';
        }
      },
        {title: '创建时间', field: 'createTime', width: 150, sortable: true},
        {title: '修改时间', field: 'modifyTime', width: 150, sortable: true}
      ]],
      toolbar: [{
        text: '增加',
        iconCls: 'icon-add',
        handler: function () {
          append()
        }
      }, '-', {
        text: '删除',
        iconCls: 'icon-remove',
        handler: function () {
          remove();
        }
      }, '-', {
        text: '修改',
        iconCls: 'icon-edit',
        handler: function () {
          editFun();
        }
      }, '-', {
        text: '清除',
        iconCls: 'icon-clear',
        handler: function () {

        }
      }]
    });
  });

  function editFun() {
    var rows = $('#admin_usermanager_datagrid').datagrid('getChecked');
    if (rows.length == 1) {
      var d = $('<div/>').dialog({
        width: 300,
        height: 300,
        href: '${pageContext.request.contextPath}/admin/user-edit.jsp',
        modal: true,
        title: '编辑用户',
        buttons: [{
          text: '编辑',
          handler: function () {
            $('#admin_useredit_editForm').form('submit', {
              url: '${pageContext.request.contextPath}/userAction!edit',
              success: function (data) {
                var ob = $.parseJSON(data);
                if (ob.success) {
                  d.dialog('close');
//                  $('#admin_usermanager_datagrid').datagrid('reload');
                  $('#admin_usermanager_datagrid').datagrid('updateRow',{
                    index: $('#admin_usermanager_datagrid').datagrid('getRowIndex', rows[0]),
                    row: ob.obj
                  });
                }
                $.messager.show({
                  title: '提示',
                  msg: ob.msg,
                  timeout: 5000,
                  showType: 'slide'
                });
              }
            });
          }
        }],
        onClose: function () {
          $(this).dialog("destroy");
        },
        onLoad: function () {
          var form = $('#admin_useredit_editForm');
          form.form('load', rows[0]);
        }
      });
    } else {
      $.messager.alert({
        title: '提示',
        msg: '请选择一条信息进行编辑!',
      });
    }
  }

  function remove() {
    var rows = $('#admin_usermanager_datagrid').datagrid('getChecked');
    var ids = [];
    if (rows.length > 0) {
      $.messager.confirm('确认', '您是否要删除当前选中的项目?', function (r) {
        if (r) {
          for (var i = 0; i < rows.length; i++) {
            ids.push(rows[i].id);
          }
          $.ajax({
            url: '${pageContext.request.contextPath}/userAction!remove',
            data: {
              ids: ids.join(',')
            },
            dataType: 'json',
            success: function (data) {
              $('#admin_usermanager_datagrid').datagrid('load');
              $('#admin_usermanager_datagrid').datagrid('unselectAll');
              $.messager.show({
                title: '提示',
                msg: data.msg
              });
            }
          });
        }
      });
    } else {
      $.messager.show({
        title: '提示',
        msg: '请勾选要删除的记录!'
      });
    }
  }

  function searchFun() {
    var val = $('#admin_usermanager_layout input[name=name]').val();
    $('#admin_usermanager_datagrid').datagrid('load', {
      name: val
    });
  }

  function clearFun() {
    $('#admin_usermanager_layout input[name=name]').val('');
    $('#admin_usermanager_datagrid').datagrid('load', {});
  }

  function append() {
    $('#admin_usermanager_addForm input').val('');
    $('#admin_usermanager_addDialog').dialog('open');
  }
</script>

<div id="admin_usermanager_layout" class="easyui-layout" data-options="fit:true,border:false">
  <div data-options="region:'north',title:'查询条件',border:false" style="height: 100px;">
    <form id="admin_usermanager_searchForm">
      <input name="name" type="text"/>
      <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="searchFun()">查询</a>
      <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-clear',plain:true" onclick="clearFun()">清除</a>
    </form>
  </div>
  <div data-options="region:'center'">
    <table id="admin_usermanager_datagrid"></table>
  </div>
</div>

<div id="admin_usermanager_addDialog" class="easyui-dialog"
     data-options="closed:true,modal:true,title:'添加用户',buttons:[{
        text:'添加',
        iconCls:'icon-add',
        handler:function(){
          $('#admin_usermanager_addForm').form('submit', {
            url: '${pageContext.request.contextPath}/userAction!add',
            success: function (data) {
              var ob = $.parseJSON(data);
              if (ob.success) {
                <%--$('#admin_usermanager_datagrid').datagrid('load');--%>
                <%--$('#admin_usermanager_datagrid').datagrid('appendRow', ob.obj);--%>
                $('#admin_usermanager_datagrid').datagrid('insertRow',{
                  index: 0,	// index start with 0
                  row: ob.obj
                });
                $('#admin_usermanager_addDialog').dialog('close');
              }
              $.messager.show({
                  title:'提示',
                  msg:ob.msg,
                  timeout:5000,
                  showType:'slide'
              });
            }
          });
        }
     }]" style="width: 300px; height: 300px;" align="center">
  <form id="admin_usermanager_addForm" method="post">
    <table>
      <tr>
        <th>编号</th>
        <td><input type="text" name="id" class="easyui-validatebox" data-options="readonly:true"></td>
      </tr>
      <tr>
        <th>登录名称</th>
        <td><input type="text" class="easyui-validatebox" data-options="required:true" name="name"></td>
      </tr>
      <tr>
        <th>密码</th>
        <td><input type="password" class="easyui-validatebox" data-options="required:true" name="pwd"></td>
      </tr>
    </table>
  </form>
</div>