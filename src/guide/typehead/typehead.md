
```html
  <input name="name" onchange="fire()" id="searchInput"
  class="form-control shadow-none py-2" type="text"
  value="{{ empty(Session::get('success')) ? $searchBag['name'] ?? '' : '' }}"
  placeholder="Search by name..." autocomplete="off">
```

```js
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-3-typeahead/4.0.1/bootstrap3-typeahead.min.js"></script>
    <script>
        $(document).ready(function() {
            var route = "{{ route('dev.memberbody.show') }}";

            $('#searchInput').typeahead({
                source: function(term, process) {
                    return $.get(route, {
                        term: term
                    }, function(data) {
                        return process(data);
                    });
                },
                displayText: function(item) {
                    return item.with;
                    return `${item.name} | ${item.fbcci_voter_no}`;
                },
                updater: function(item) {
                    console.log(item);

                    var selectedNameId = item
                        .id;
                    $('#searchInput').val(item.name)
                    $('#selectedNameId').val(selectedNameId);
                    return item.name;
                },
                afterSelect(param){
                    fire();
                }
            });

            // Handle change event (optional)
            $('#searchInput').change(function() {
                var selectedNameId = $('#selectedNameId').val();
                // Do something with the selected ID
                console.log("Selected Name ID:", selectedNameId);
            });
        });
 </script>
```
