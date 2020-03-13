<#include "/abstracted/common.ftl">
<#include "/abstracted/commonForEntity.ftl">
<#--定义主体代码-->
<#assign code>
<@call this.addImport("${this.commonPackage}.pojo.po.AbstractPO")/>
<#--判断是否继承特殊接口-->
<#assign implementsVersion=false>
<#assign implementsDeleteSign=false>
<#assign implementsCreatedBy=false>
<#assign implementsCreatedTime=false>
<#assign implementsOperatedBy=false>
<#assign implementsOperatedTime=false>
<#assign implementsCreated=false>
<#assign implementsOperated=false>
<#assign implementsCreatedOperatedDeleted=false>
<#assign implementsCreatedOperatedDeletedVersion=false>
<#--判断是否继承单一接口-->
<#if this.delField??>
    <#assign implementsDeleteSign=true>
</#if>
<#if this.createdByField??>
    <#assign implementsCreatedBy=true>
</#if>
<#if this.createdTimeField??>
    <#assign implementsCreatedTime=true>
</#if>
<#if this.operatedByField??>
    <#assign implementsOperatedBy=true>
</#if>
<#if this.operatedTimeField??>
    <#assign implementsOperatedTime=true>
</#if>
<#if this.versionField??>
    <#assign implementsVersion=true>
</#if>
<#--判断是否继承合并接口-->
<#if implementsCreatedBy && implementsCreatedTime>
    <#assign implementsCreated=true>
</#if>
<#if implementsOperatedBy && implementsOperatedTime>
    <#assign implementsOperated=true>
</#if>
<#if implementsCreated && implementsOperated && implementsDeleteSign>
    <#assign implementsCreatedOperatedDeleted=true>
</#if>
<#if implementsCreated && implementsOperated && implementsDeleteSign && implementsVersion>
    <#assign implementsCreatedOperatedDeletedVersion=true>
</#if>
<#--构建继承串-->
<#assign implementsStr="">
<#if implementsCreatedOperatedDeletedVersion>
    <#assign implementsStr+=" CreatedOperatedDeletedVersion,">
    <@call this.addImport("${this.commonPackage}.pojo.po.CreatedOperatedDeletedVersion")/>
<#elseIf implementsCreatedOperatedDeleted>
    <#assign implementsStr+=" CreatedOperatedDeleted,">
    <@call this.addImport("${this.commonPackage}.pojo.po.CreatedOperatedDeleted")/>
<#else>
    <#if implementsCreated>
        <#assign implementsStr+=" Created,">
        <@call this.addImport("${this.commonPackage}.pojo.po.Created")/>
    <#elseIf implementsCreatedBy>
        <#assign implementsStr+=" CreatedBy,">
        <@call this.addImport("${this.commonPackage}.pojo.po.CreatedBy")/>
    <#elseIf implementsCreatedTime>
        <#assign implementsStr+=" CreatedTime,">
        <@call this.addImport("${this.commonPackage}.pojo.po.CreatedTime")/>
    </#if>
    <#if implementsOperated>
        <#assign implementsStr+=" Operated,">
        <@call this.addImport("${this.commonPackage}.pojo.po.Operated")/>
    <#elseIf implementsOperatedBy>
        <#assign implementsStr+=" OperatedBy,">
        <@call this.addImport("${this.commonPackage}.pojo.po.OperatedBy")/>
    <#elseIf implementsOperatedTime>
        <#assign implementsStr+=" OperatedTime,">
        <@call this.addImport("${this.commonPackage}.pojo.po.OperatedTime")/>
    </#if>
    <#if implementsDeleteSign>
        <#assign implementsStr+=" Deleted,">
        <@call this.addImport("${this.commonPackage}.pojo.po.Deleted")/>
    </#if>
    <#if implementsVersion>
        <#assign implementsStr+=" Version,">
        <@call this.addImport("${this.commonPackage}.pojo.po.Version")/>
    </#if>
</#if>
<#if implementsStr!="">
    <#assign implementsStr=" implements"+implementsStr?removeEnding(",")>
</#if>
<@call this.printClassCom("${this.title}" "${this.desc}")/>
<#if this.projectFeature.lombokEnabled>
    <@call this.addImport("lombok.Data")/>
    <@call this.addImport("lombok.EqualsAndHashCode")/>
@Data
@EqualsAndHashCode(callSuper=true)
</#if>
public class ${this.className}PO extends AbstractPO${implementsStr} {

<#list this.fields as id,field>
    <#--import字段类型-->
    <@call this.addFieldTypeImport(field)/>
    /**
${JavaTemplateFunction.convertCommentDisplayWithIndentStar(field.fetchComment())}
    <#if field.dicType??>
     * @see ${this.getConstFullClassPath(field.dicType)}
    </#if>
     */
    private ${field.jfieldType} ${field.jfieldName};

</#list>
    <#list this.holds! as otherEntity,mtm>
        <@call this.addImport("java.util.List")/>
    private List<${otherEntity.className}PO> ${lowerFirstWord(otherEntity.className)}POList;

    </#list>
<#if !this.projectFeature.lombokEnabled>
    <#list this.fields as id,field>
        <@call JavaTemplateFunction.printGetterSetterForPO(field)/>
    </#list>
    <#list this.holds! as otherEntity,mtm>
        <@call JavaTemplateFunction.printGetterSetterList("${otherEntity.className}PO","${otherEntity.className}PO")/>
    </#list>
</#if>
<#if implementsDeleteSign && this.delField.jfieldName!="deleted">
    @Override
    public Boolean getDeleted() {
        return this.${this.delField.jfieldName};
    }

    @Override
    public void setDeleted(Boolean deleted) {
        this.${this.delField.jfieldName} = deleted;
    }

</#if>
<#if implementsCreatedBy && this.createdByField.jfieldName!="createdBy">
    @Override
    public String getCreatedBy() {
        return this.${this.createdByField.jfieldName};
    }

    @Override
    public void setCreatedBy(String createdBy) {
        this.${this.createdByField.jfieldName} = createdBy;
    }

</#if>
<#if implementsCreatedTime && this.createdTimeField.jfieldName!="createdTime">
    @Override
    public Date getCreatedTime() {
        return this.${this.createdTimeField.jfieldName};
    }

    @Override
    public void setCreatedTime(Date createdTime) {
        this.${this.createdTimeField.jfieldName} = createdTime;
    }

</#if>
<#if implementsOperatedBy && this.operatedByField.jfieldName!="operatedBy">
    @Override
    public String getOperatedBy() {
        return this.${this.operatedByField.jfieldName};
    }

    @Override
    public void setOperatedBy(String operatedBy) {
        this.${this.operatedByField.jfieldName} = operatedBy;
    }

</#if>
<#if implementsOperatedTime && this.operatedTimeField.jfieldName!="operatedTime">
    @Override
    public Date getOperatedTime() {
        return this.${this.operatedTimeField.jfieldName};
    }

    @Override
    public void setOperatedTime(Date createdTime) {
        this.${this.operatedTimeField.jfieldName} = createdTime;
    }

</#if>
<#if implementsVersion && this.versionField.jfieldName!="version">
    @Override
    public Integer getVersion() {
        return this.${this.versionField.jfieldName};
    }

    @Override
    public void setVersion(Integer version) {
        this.${this.versionField.jfieldName} = version;
    }

</#if>

}
</#assign>
<#--开始渲染代码-->
package ${poPackageName};

<@call this.printImport()/>

${code}
