{extends designs/site.tpl}

{block title}{if $data->isPhantom}{_ 'Create'}{else}{_('Edit %s')|sprintf:$data->Title|escape}{/if} &mdash; {_ 'Projects'} &mdash; {$dwoo.parent}{/block}

{block css}
    {$dwoo.parent}
    {cssmin array(
        'templates/projects/projectEdit.css'
    )}
{/block}

{block js-bottom}
    {$dwoo.parent}
    {jsmin "epiceditor.js"}
    {jsmin "pages/project-edit.js"}
    {jsmin "features/tag-fields.js"}
{/block}

{block content}
    {$Project = $data}

    <div class="container">
        <div class="row">
            <div class="col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">
                <div class="page-header">
                    <h1>
                        {if $Project->isPhantom}
                            {_ "Create new project"}
                        {else}
                            {_("Edit project %s")|sprintf:$Project->Title|escape}
                        {/if}
                    </h1>
                </div>

                {if !$Project->isValid}
                <div class="error well">
                    <strong>{_ "There were problems with your entry:"}</strong>
                    <ul class="errors">
                    {foreach item=error key=field from=$Project->validationErrors}
                        <li>{$error}</li>
                    {/foreach}
                    </ul>
                </div>
                {/if}

                <form method="POST">
                    <div class="form-group">
                        <label for="field-title">{_ "Title"}:</label>
                        <input name="Title" id="field-title" class="form-control" placeholder="{_ 'Train Schedule Analyzer'}" value="{refill field=Title default=$Project->Title}" />
                    </div>
                    <div class="form-group">
                        <label for="field-url-users">{_ "URL for Users"}:</label>
                        <input type="url" name="UsersUrl" id="field-url-users" class="form-control" placeholder="{_ 'http://mypublicapp.org'}" value="{refill field=UsersUrl default=$Project->UsersUrl}" />
                    </div>
                    <div class="form-group">
                        <label for="field-url-developers">{_ "URL for Developers"}:</label>
                        <input type="url" name="DevelopersUrl" id="field-url-developers" class="form-control" placeholder="http://github.com/..." value="{refill field=DevelopersUrl default=$Project->DevelopersUrl}"/>
                        <button type="submit" class="btn btn-primary"  data-toggle="modal" data-target="#syncReadmeModal">Sync README</button>
                    </div>
                    <div class="form-group">
                        <label for="field-chat-channel">{_ "Chat Channel/Hashtag"}:</label>
                        <input name="ChatChannel" id="field-chat-channel" class="form-control" placeholder="train_schedule_analyzer" value="{refill field=ChatChannel default=$Project->ChatChannel}" pattern="[A-Za-z0-9_-]+" title="Hash tag containing only letters, numbers, dashes or underscores without leading #"/>
                    </div>
                    <div class="form-group">
                        <label for="topicTagsInput">{_ 'Topic Tags'}:</label>
                        <input type="tags" data-tag-prefix="topic" id="topicTagsInput" class="form-control" name="tags[topic]" placeholder="{_ 'Education, Mapping, Crime'}" value="{refill field=tags.topic default=Tag::getTagsString($Project->Tags, topic)}"/>
                    </div>
                    <div class="form-group">
                        <label for="techTagsInput">{_ 'Technology Tags'}:</label>
                        <input type="tags" data-tag-prefix="tech" id="techTagsInput" class="form-control" name="tags[tech]" placeholder="{_ 'PHP, Bootstrap, JavaScript'}" value="{refill field=tags.tech default=Tag::getTagsString($Project->Tags, tech)}"/>
                    </div>
                    <div class="form-group">
                        <label for="eventTagsInput">{_ 'Event Tags'}:</label>
                        <input type="tags" data-tag-prefix="event" id="eventTagsInput" class="form-control" name="tags[event]" placeholder="{_ 'Education Hackathon 2014'}" value="{refill field=tags.event default=Tag::getTagsString($Project->Tags, event)}"/>
                    </div>
                    <p id="project-stage"><b>{_ 'Stage'}:</b></p>
                    <div aria-labelledby="project-stage">
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Commenting" {refill field=Stage default=$Project->Stage|default:Commenting checked=Commenting}>
                                <b>{_ Commenting}</b>: {Laddr\Project::getStageDescription(Commenting)}
                            </label>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Bootstrapping" {refill field=Stage default=$Project->Stage checked=Bootstrapping}>
                                <b>{_ Bootstrapping}</b>: {Laddr\Project::getStageDescription(Bootstrapping)}
                            </label>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Prototyping" {refill field=Stage default=$Project->Stage checked=Prototyping}>
                                <b>{_ Prototyping}</b>: {Laddr\Project::getStageDescription(Prototyping)}
                            </label>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Testing" {refill field=Stage default=$Project->Stage checked=Testing}>
                                <b>{_ Testing}</b>: {Laddr\Project::getStageDescription(Testing)}
                            </label>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Maintaining" {refill field=Stage default=$Project->Stage checked=Maintaining}>
                                <b>{_ Maintaining}</b>: {Laddr\Project::getStageDescription(Maintaining)}
                            </label>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Drifting" {refill field=Stage default=$Project->Stage checked=Drifting}>
                                <b>{_ Drifting}</b>: {Laddr\Project::getStageDescription(Drifting)}
                            </label>
                        </div>
                        <div class="radio">
                            <label>
                                <input type="radio" name="Stage" value="Hibernating" {refill field=Stage default=$Project->Stage checked=Hibernating}>
                                <b>{_ Hibernating}</b>: {Laddr\Project::getStageDescription(Hibernating)}
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="README">{_ 'README(.md)'}</label>
                        <div class="controls">
                            <textarea name="README" class="input-block-level" rows="10">{refill field=README default=$Project->README}</textarea>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">{if $Project->isPhantom}{_ 'Create Project'}{else}{_ 'Save Changes'}{/if}</button>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="syncReadmeModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Overwriting README</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Pulling readme from developer url. Are you sure you want to continue?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary">Import</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
{/block}
