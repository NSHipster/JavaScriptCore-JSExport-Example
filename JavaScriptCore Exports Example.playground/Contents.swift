import JavaScriptCore

let context = JSContext()!

context.setObject(Person.self,
                  forKeyedSubscript: "Person" as NSString)

context.evaluateScript(#"""
function loadPeople(json) {
    return JSON.parse(json)
               .map((attributes) => {
        let person = Person.createWithFirstNameLastName(
            attributes.first,
            attributes.last
        );
        person.birthYear = attributes.year;

        return person;
    });
}
"""#)

let json = """
[
    { "first": "Grace", "last": "Hopper", "year": 1906 },
    { "first": "Ada", "last": "Lovelace", "year": 1815 },
    { "first": "Margaret", "last": "Hamilton", "year": 1936 }
]
"""

guard let loadPeople = context.objectForKeyedSubscript("loadPeople"),
      let people = loadPeople.call(withArguments: [json])?.toArray()
else {
    fatalError()
}

guard let url = Bundle.main.url(forResource: "mustache", withExtension: "js") else {
    fatalError("missing resource mustache.js")
}

context.evaluateScript(try String(contentsOf: url),
                       withSourceURL: url)
// call withSourceURL to determine where something went wrong

let template = """
{{#people}}
{{fullName}}, born {{birthYear}}
{{/people}}
"""

let result = context.objectForKeyedSubscript("Mustache")
                    .objectForKeyedSubscript("render")
                    .call(withArguments: [template, ["people": people]])!

print(result)
