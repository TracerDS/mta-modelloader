# MTA Modelloader #

## About
This resource has been created to ease the process
of creating custom models via `engineRequestModel`.

API is simple to use and easy to maintain. Enjoy :>

## Install
- Go to the [Releases](https://github.com/TracerDS/mta-modelloader/releases) panel
- Download recent version
- Put it in your `resources` folder
- Enjoy

## API
```lua
element CreateModel(string modelType, ...)
```
Type: <span style='font-weight:bold;color:rgb(117,117,255);'>Shared</span>

Creates model with specified model type (ped, vehicle, object). Returns the created model.
<hr/>

```lua
number RequestModel(string modelType, string modelName, table modelData)
```
Type: <span style='font-weight:bold;color:rgb(255, 50, 50);'>Client</span>

Requests a new ID for the model with model data to replace (col, txd, dff, conf). Returns valid `id` on success.
<hr/>

```lua
boolean ReplaceModel(element/table model, number id)
```
Type: <span style='font-weight:bold;color:rgb(117,117,255);'>Shared</span>

Replaces model with the requested ID. When `model` is a table, it is assumed that the table is indexed numerically and thus it will try to replace all elements in the table.
Returns `true` when model has been successfully replaced.
<hr/>

```lua
boolean FreeModel(number id)
```
Type: <span style='font-weight:bold;color:rgb(255, 50, 50);'>Client</span>

Frees the requested model ID. Returns `true` on success.
<hr/>

```lua
table GetModels()
```
Type: <span style='font-weight:bold;color:rgb(117,117,255);'>Shared</span>

Returns synced and replaced models.
<hr/>

```lua
table GetIDs([ player playerToFetch ])
```
Type: <span style='font-weight:bold;color:rgb(117,117,255);'>Shared</span>

Returns requested model IDs. When called on the server, it will return requested ids for <b>every</b> player unless specified otherwise via the `playerToFetch` parameter.
This parameter exists <b>only</b> on the <span style='font-weight:bold;color:rgb(232, 115, 0);'>server</span>.