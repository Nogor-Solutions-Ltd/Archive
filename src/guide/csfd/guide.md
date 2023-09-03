---
title: CSFD Documentation
---


## Table of Contents

-   [Laravel](#laravel)
    -   Eloquent
    -   Query Builder
    -   Pagination
    -   Model
    -   Relationship
    -   Hooks
-   [Vue](#vue)
    -   Network
    -   Slot
    -   Props
    -   Base table
    -   View base table
    -   Search Block
    -   Watch
    -   Validation
-   [Tooling](#tooling)
    -   Pint
-   [Style](#style)
    -   Laravel
    -   Vue
    -   MySQL
-   [Ref](#ref)
    -   Vue
    -   Laravel
-   [Package](#Package)

# Laravel

In this section you will find, laravel related information regarding the CSFD **_(Customize System for Faster Development)_**

#### Database

Database section contain various information regarding the database manupulation,ORM and much more.

#### Order

-   Order by a specific columns

```php
$query->orderByRaw("FIELD(status, 'Pending', 'Success')")
```

#### Date

-   From date / To date Contain a single date:

```php
// controller:
$startDate = $request->from_date ?? '1900-01-01';
$endDate = $request->to_date ?? now()->toDateString();
$query->whereBetween('notice_date', [$startDate, $endDate]);
```
```vue
<div class="col-2">
    <div class="form-element">
        <input
        placeholder="From date"
        v-model="search_data.from_date"
        class="form-control form-control-sm shadow-none"
        type="text"
        onfocus="(this.type='date')"
        id="date"
        />
    </div>
</div>
<div class="col-2">
    <div class="form-element">
        <input
        placeholder="To Date"
        v-model="search_data.to_date"
        class="form-control form-control-sm shadow-none"
        type="text"
        onfocus="(this.type='date')"
        id="date"
        />
    </div>
</div>
```

-   From date / To date which contain two date:

```php
// controller:
 $startDate = $request->from_date ?? '1900-01-01';
        $endDate = $request->to_date ?? now()->toDateString();
        $query->whereDate('start_date', '>=', $startDate)
            ->whereDate('end_date', '<=', $endDate);
```

# Relationship

-   Belongs to:

```php
return $this->belongsTo(Foo::class, 'foreign_key', 'owner_key');
return $this->belongsTo(Album::class, "album_id","id");
```

-   Has One:

```php
return $this->hasOne(Foo::class, 'foreign_key', 'local_key');
return $this->hasOne(Slider::class, 'slider_id', 'id');
```

-   Has Many:

```php
 return $this->hasMany(Foo::class, 'foreign_key', 'local_key');
 return $this->hasMany(Foo::class, 'slider_id', 'id');
```

-   Search on Relationship:

```php
$query = Video::with('model')->whereHas('album', function ($query) use ($request) {
    $query->whereLike('name',$request->value );
})->oldest('sorting');

```

#### Upoading

-   Image Upload:

```php
if (!empty($thumbnail)) {
    $data['thumbnail'] = $this->upload($thumbnail, 'video', null, $base64 = false);
}
```

```php
if (!empty($thumbnail)) {
    $data['thumbnail'] = $this->upload($thumbnail, 'video', null, $base64 = true);
} else {
    $data['thumbnail'] = $this->oldFile($video->thumbnail);
}
```

# Vue

This section contains resources related `vue.js`.

#### Add a extra button in "Base-Table"

In your index page , inside created() put this code and modify it.

```js
this.table.routes.array = [
  {
    title:"your tile",
    route: "your.route.index",
    icon: "home", // fa fa-[icon]
    class: "text-danger",
    isQuery: true, // create?id="id"
  },
];
```

#### Custom Laravel PaginationIn Vue

`Ref: Genform [global/genform]`
`Vue template`

```js
<template v-for="(item, index) in laravelData.data" :key="index">
</template>

<laravel-pagination
    :data="laravelData"
    @pagination-change-page="getResults"
></laravel-pagination>
```

`Script`

```js
 data() {
    return {
      laravelData: {},
    };
  },
  methods: {
    getRecords() {
      axios
        .get("get/employee-records", {
          params: {
            id: this.id,
          },
        })
        .then((res) => {
          this.data = res.data;
        });
    },
    getResults(page) {
      if (typeof page === "undefined") {
        page = 1;
      }
      axios
        .get("/get/employee-records", {
          params: {
            page: page,
            id: this.id,
          },
        })
        .then((res) => {
          this.laravelData = res.data;
        })
        .catch((error) => {
          console.error("Error fetching data:", error);
        });
    },
  },
  created() {
    this.getResults();
  },
```

#### Add all field in form data
```js
var form = document.getElementById("form");
var formData = new FormData(form);
for (var key in this.data) {
    formData.append(key, this.data[key]);
}
```

#### Custom Validation:

`Laravel`

```php
$v = validator($request->all(), [
    'avatar' => 'required|image|mimes:jpeg,png,jpg|max:2048',
    'id' => 'required|integer|exists:employees,id',
]);

if ($v->fails()) return response()->json(['errors' => $v->errors()], 422);
```

`Vue`

```js
this.store("employee/upload/profile", formData);
```

#### Image Dimension Validation
``` Image File Component ```
```vue
 <File ref="childRef" title='Logo (W:149px,H:200px)' field='data.logo' mime='img' req="true" fileClassName='data.logo' />
```

```
Image validation
```
```js
.custom(function(){
if (!Validator.isEmpty(value)) {
const img = new Image();
img.onload = function() {
    const width = img.width;
    const height = img.height;
    const expectedWidth = 149;
    const expectedHeight = 200;

    if (width >= expectedWidth && height >= expectedHeight) {
      return "Image dimensions are valid."
    } else {
        vm.$toast(`Image dimensions should be width:${expectedWidth}px, height:${expectedHeight}px.`,'error')
        vm.data.logo = "";
        vm.image="";
        vm.$refs.childRef.removeImage();
      }
};

const reader = new FileReader();
reader.onloadend = function() {
    img.src = reader.result;
};

reader.readAsDataURL(value);
}
});
```


# Use Thirdparty Resizer

For ref, please see the news module, migrations.

// In Controller

```php

// In store()
 $image = $request->image_base64;

if (! empty($image)) {
    $data['image'] = cloudflare(file: $image, folder: 'news', resizeSize: '600x600,200x200', base64: true);
}


// In update()
$image = $request->image_base64;

if (! empty($image)) {
    $data['image'] = cloudflare(file: $image, folder: 'album', resizeSize: '600x600,200x200', base64: true);
} else {
    $data['image'] = $news->image;
}

```

// In Vue

```js
<template>
<File
        title="Image"
        field="data.original_image"
        mime="img"
        fileClassName="file2"
        :showCrop="true"
        col="3"
        vHeight="600"
        vWidth="600"
        vSizeInKb="500"
      />

      <GlobalCrop
        field="data.original_image"
        v-on:update:modelValue="data.original_image = $event"
        :image="image.original_image"
        :aspectRatio="{ aspectRatio: 600 / 600 }"
        :minWidth="600"
        :minHeight="600"
      ></GlobalCrop>
      </template>
      <script>
        export default{
             data() {
    return {
      model: model,
      data: {
      },
      image: { original_image: "" },
    };
  },
  provide() {
    return {
      validate: this.validation,
      data: () => this.data,
      image: this.image,
    };
  },

  // In Store

  if (res) {
          var form = document.getElementById("form");
          var formData = new FormData(form);
          formData.append("image_base64", this.data.original_image);
          formData.append("status", this.data.status);

          if (this.data.id) {
            this.update(this.model, formData, this.data.slug, "image");
          } else {
            this.store(this.model, formData);
          }
        }
        }
      </script>
```

#### Cloudflare Resizer
```php
$arrayOfImage = cloudflare(file: $image, folder: 'news', resizeSize: '600x600,200x200', base64: true);
```
#### Image Intervation Resizer
```php
 $arrayOfImage = use_intervation(file: $file, folder: $baseFolder, resizeSize: $resizeSize);
```


#### Custom Add / Back button

Inside the, template "create-form" , insert it [Your vue file] , and you can modify it via route.

```js
<create-form @onSubmit="submit">
    <template v-slot:button>
    <AddOrBackButton
    :route="'slider' + '.index'"
    :portion="slider"
    :icon="'fas fa-backward'"
    />
    </template>
<create-form @onSubmit="submit">

<slot name="button">
  <AddOrBackButton
    :route="model + '.index'"
    :portion="model"
    :icon="'fas fa-backward'"
  />
</slot>
```

#### Use Crop in Image

-   In vue template:

```js
<!------------ Single Input ------------>
    <div class="row align-items-center">
  <File
    title="Slider"
    field="data.image"
    mime="img"
    fileClassName="file2"
    :req="true"
    :showCrop="true"
  />

<!------------ Single Input ------------>
 <GlobalCrop
    field="data.image"
    v-on:update:modelValue="data.image = $event"
    :image="image.image"
    :aspectRatio="{ aspectRatio: this.slider.width / this.slider.height }"
    :width="this.slider.width"
    :height="this.slider.height"
></GlobalCrop>
```

-   In vue data():

```js
data(){
    return{
        data:{
            image
        },
        image: { image: "" },
    }
}
```

-   In vue provide:

```js
 provide() {
    return {
       data: () => this.data,
      image: this.image,
    };
  },

```

-   In vue store():

As we are using the cropper , we have to sent it through the 'this.data' property.

```
this.store(this.model,this.data,"route"); // Here, you can put your own route.
```

-   In controller store()

```php
$image = $request->image;
$this->upload($image, $path, null, $base64 = true);
```

-   In controller update()
    As from frontend you will recive the image as text not a file , that's why you have to check , if the image is text and same as in Database, then it is an old image.

```
if ($model->image !== $request->image) {
    $data['image'] = $this->upload($model->image, 'foo', $foo->image, $base64 = true);
} else {
    $data['image'] = $this->oldFile($model->image);
}
```

#### Resize in Blade

You can resize image in blade, this resizer will helps you to resize the images, also we have
Image Intervention package. After cropping the image, it becomes base64, you should store it as
file in disk. Then resize it later in blade. We have tested the performance , and can assure you
it works.

`package:  "bkwld/croppa": "^6.0"`

```html
<img
    src="{{ Croppa::url($news->image, 600, 200, ['resize', 'quality' => 100]) }}"
/>
```

#### Multiple Select with Dropdown and Search

ref : `@/profile/create.vue`

```js
<MultipleSelectContainer
        field="data.categories"
        :req="true"
        title="Categories"
      >
    <MultipleSelect
        style="color: brown"
        v-model="data.categories"
        :options="categories"
        :settings="{
        settingOption: name,
        settingOption: value,
        multiple: true,
        }"
        @change=""
        @select=""
    />
</MultipleSelectContainer>

data(){
    return{
        categories:[],
    }
},
methods:{
    getCategory() {
      axios.get(`category?page=1&allData=true`).then((res) => {
        var n = res.data.map((e) => {
          return {
            text: e.title,
            id: e.id,
          };
        });
        const categories = JSON.parse(JSON.stringify(n));
        this.categories = categories;
      });
    },
}
```

### Custom Select for Manual Dropdown:

-   `Example 01: `

#### In Template

```js
<!------------ Single Input ------------>
<v-select-container title="Button type">
<select
    v-model="data.types"
    class="form-select shadow-none"
    aria-label="Default select example"
    required
>
    <template v-for="(type, index) in types" :key="index">
    <option value="" v-if="index === 0">-- Select --</option>
    <option :value="type">
        {{ type }}
    </option>
    </template>
</select>
</v-select-container>

data(){
  return{
    types: ["Staff", "Contractor", "Supplier"],
  }
}
```

-   `Example 02: `

```
<v-select-container
        field="data.module_name"
        :req="true"
        title="Module name"
      >
    <v-select
      v-model="data.module_name"
      label="name"
      :reduce="(obj) => obj.value"
      :options="modules"
      placeholder="--Select One--"
      :closeOnSelect="true"
      :req="true"
    ></v-select>
</v-select-container>

data(){
  return{
     modules: [
      { name: "Notice", value: "notice" },
      { name: "Events", value: "events" },
      { name: "News", value: "news" },
    ],
  }
}

```

#### In data()

```js
data(){
    return{
        data:{
             button_type: "",
        }
    }
}
```

# Remove a specific button of base table:

create a variable and define the routes , then inject it in the data property inside table.

```
const routes = {
  view: "contact.show",
  destroy: "contact.destroy"
};

 table: {
        columns: tableColumns,
        routes: routes, // This.
        datas: [],
        meta: [],
        links: []
      }
```

#### Show relational Data in "View base table":

```js
// In view.vue
 data() {
    return {
      model: model,
      data: {},
      extra_row: {
        category: ["category", ["title"]],
        session: ["session", ["title"]],
        member: ["member", "name"],
        // committee: ["committee", ["title"]],
      },
      fileColumns: [],
    };
  },

  in controller show:
  return Committee::with('session','category')->where('id',$id)->first();
```

#### View Base Table:

Hints: **_`View => ViewPage => ViewBaseTable`_**

```
 data() {
    return {
      model: model,
      data: {},
      fields: ["id", "url"], // Which property of data you want to showcase.
      belongs_to: { // This one is responsible for relational data.
        data: {}, // Relational data.
        fields: ["name"], // Which property of data you want to showcase.
        model: "album", // This the model which will the url/route redirect.
      },
    };
  },

```

#### Filters:

Daily resuable function to manupulate your string.

#### enFormat()

You can use this global function to format the date as 11 May 2023 for consistency over the project.

```js
$filter.enFormat(history.login_at) // created_at or updated_at
```

#### capitalize()

You can capitalize you word.

```js
$filter.capitalize("sunday");
```

### Networking in Vue js:

This section contains the example of using https.

-   Get all Data

```js
axios.get('service?page=1&allData=true').then((res)=>console.log(res.data));
```

### Global Function

CSFD contains various global function to interact with https.

#### get_data()

First parameter is for url, you can pass whatever you like. then second parameter is for data object,
where you want to put the data after fetching it in your component.

```js
get_data("url","data property");
```

#### callApi()

Call API is responsible for calling the API endpoint with data object. First parameter , is method "GET/POST/PUT/ANY" then your "url" , then the "dataObj"

```js
callApi(method, url, dataObj = null)
```

#### get_sorting()

To get the sorting of any model , you can use this function.
Namespace :

```js
get_sorting(namespace)

Example 01 : App\Models\Content will be like get_sorting("Content")",
Example 02: App\Models\Website\Content will be like get_sorting("Website-Content")
```

#### destroy_data()

This one is responsible for deleting a resource from the database.

```js
destroy_data(model_name, id, search_data=null)
```

# Utility function:

Utility function contains various utility functions.

#### scrollTop()

To modify the scroll behaviour.

```js
 this.scrollTop(0, 0);
```

#### print()

Print the html content as pdf.

```js
this.print(elementId, documentTitle)
or
<button @click="print(elementId, documentTitle)"></button>
```

#### Disable Index page base table Button:

```js
 <index-page :button="false">...</index-page>
```

#### Disable Base table action button:

```js
methods:{
    injectCustomRoute() {
     this.table.routes.edit = null;
    },
},

created()
{
    this.injectCustomRoute();
}
```

### Watch:

```
watch: {
    // Nested.
    "data.has_button"(current, old) {
      if (current == "No") {
        this.data.button_type = "";
      }
    },
    // Watch on global functionality
    $route(newRoute, lastRoute) {
      this.isActiveRoute(this.currentRouteName);
    },
  },
```

#### Validation:

## Vue.js

> Vue-Simple Validator `--https://simple-vue-validator.netlify.app/

#### A simple validation

```
"data.slider_id": function (value = null) {
      return Validator.value(value).required("Slider is required");
    },
```

#### A custom validation

```vue
"data.button_type": function (value = null) { const vm = this; return
Validator.value(value).custom(function (value) { if (vm.data.has_button ===
"Yes") { vm.$toast("Button type is required", "warning"); } }); },
```

```
"data.button_type": function (value = null) {
      const vm = this;
      return Validator.value(value).custom(function (value) {
        if (vm.data.has_button === "Yes") {
          return "Button type is required";
        }
      });
    },
```

#### Mobile:

```
"data.mobile": function (value = null) {
      return Validator.value(value)
        .digit()
        .regex("01+[0-9+-]*$", "Must start with 01.")
        .minLength(11)
        .maxLength(11);
    },
```

#### Show validation error in template

```
 <span v-if="validation.hasError('data.category_id')" class="input-message text-danger">
    {{ validation.firstError("data.has_button") }}
</span>

```

#### Multiple search input in CSFD Vue

ref: `admin/index.vue`

```
// In vue template:
<index-page>
    <!-- search field -->
    <template v-slot:search-field>
      <div class="col-lg-2">
        <select
          v-model="search_data.status"
          @change="search()"
          class="form-select shadow-none"
        >
          <option value="">All</option>
          <option value="active">Active</option>
          <option value="deactive">Deactive</option>
        </select>
      </div>
    </template>
  </index-page>

   search_data: {
        pagination: 10,
        field_name: "name",
        value: "",
        status: "active",
      },

// In controller:
  $query->whereAny('status', $request->status);
```

#### Advance Vue search:

ref: `activity/index.vue`

## Modal Components

For ref: `@/profile/create.vue`

#### Basic Modal

You can use the basic modal for basic operation of your application. Also, By creating a seperate component,
your model can be extendable further.

```
<div class="col-md-3">
    <button @click="openModal">Open Modal</button>
    <button @click="closeModal">Close Modal</button>
</div>

<Modal id="productModal" name="Product">
    <template v-slot:title>Color</template>
    <template v-slot:body>
        <Input
        v-model="data.title"
        field="data.title"
        title="Title"
        :req="true"
        col="12"
        />
    </template>
    <template v-slot:button>
        <Button
        title="Submit"
        process=""
        @click.prevent="productStoreModal"
        />
    </template>
</Modal>
```

```
 methods:{
    openModal() {
      $("#productModal").modal("show");
    },
    closeModal() {
      $("#productModal").modal("hide");
    },
    productStoreModal() {
      alert("Submit");
    },
 }
```

#### Inherit Modal

This modal is aims to inherit the "create.vue" file in it's body. Sometimes you need to add some data,
but navigating to different page and add it, which requires extra work.
To, avoid this, you add any data to any module form a single module.

```
 <!-------------- Inherit Modal --------------->
    <div class="col-md-3">
    <button @click="openInheritModal" class="btn btn-primary btn-sm">
        Open Inherit Modal
    </button>
    <button @click="closeInheritModal" class="btn btn-warning btn-sm">
        Close Inherit Modal
    </button>
    </div>

    <InheritModal id="faqModal" name="Faq" type="modal-xl">
    <template v-slot:title>Global Faq Create Page</template>
    <template v-slot:body>
        <faq></faq> // The components that you wanna inherit.
    </template>
    </InheritModal>
    <!-------------- Inherit Modal --------------->
```

#### Tooling

-   Code format:
    Execute: `./vendor/bin/pint`

-   Clean the activity log:
    Execute: `php artisan activitylog:clean`

-   Create Model,Factory,Seeder:
    Execute: `php artisan make:model Book -mfs`

-   Clear the cache:
    Execute: `php artisan optimize:clear`

#### Style Guide

-   Laravel:

    ###### PHP Rules:

    -   Code style must follow PSR-1, PSR-2 and PSR-12.

    ###### Crud:

    -   Try to keep controllers simple and stick to the default CRUD keywords (index, create, store, show, edit, update, destroy)
    -   Avoid something like "userCreate","userStore"

    ###### Strings:

    When possible prefer string interpolation above sprintf and the . operator.

    ```
    $notification = "welcome, {$name}.";
    ```

    ###### Ternary operators:

    Every portion of a ternary expression should be on its own line unless it's a really short expression.

    ```
    $result = $object instanceof Model ?
    $object->name :
    'A default value';
    ```

    ###### Route:

    -   Public-facing urls must use kebab-case.
    -   Route parameters should use camelCase.

    ```
    Route::get('user/create',[UserController::class,'index'])->name('user.create')
    Route::post('users',[UserController::class,'store'])->name('user.store')
    ```

#### Reference

-   Laravel
-   Vue
-   Performance [https://developer.chrome.com/docs/devtools/performance/]
-   Fast Load [https://web.dev/fast/]

#### Package:

`Vue`
| Package | README |
| ------------ | ----------------------------------------------- |
| Validator | [https://simple-vue-validator.netlify.app/] |

`Laravel`
| Package | README |
| ------------ | ----------------------------------------------- |
| Error | [https://github.com/Nogor-Solutions-Ltd/Error] |
| Activity Log | [https://github.com/spatie/laravel-activitylog] |
| Croppa | [https://github.com/BKWLD/croppa] |
