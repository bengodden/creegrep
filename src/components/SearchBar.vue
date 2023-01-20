<template>
  <div>
    <div v-for="data in databases" :key="data.name" id="database">
      <button @click="resetSearch(data.level)">{{ data.name }}</button>
    </div>
    <input type="text" v-model="query" placeholder="kīkwāy ē-natonaman?" />
    <div v-for="type in searchTypes" :key="type.Lang" id="typeOfSearch">
      <button @click="setSearchType(type)">{{ type.Lang }}</button>
    </div>
    <button @click="queryList('none')">Search</button>
  </div>

  <div v-for="result in currentResult" :key="result._id">
    <a v-bind:href="'https://itwewina.altlab.app/search?q=' + result.lemma"
      >{{ result.lemma }}
    </a>
    <span>{{ result.definition }}</span>
  </div>
</template>

<script>
import dictionaryData from "../data/cwDictionary.json";
export default {
  created() {
    this.dictionary = dictionaryData;
  },
  data() {
    return {
      query: "pahtâ",
      dictionary: [],
      currentResult: [],
      cachedResults: [{}],
      searchTypes: [
        { Lang: "nēhiyawēwin", target: "lemma" },
        { Lang: "English", target: "definition" },
        { Lang: "Verb Type", target: "verbtype" },
      ],
      searchType: { Lang: "nēhiyawēwin", target: "lemma" },
      databases: [{ name: "Dictionary", data: dictionaryData, level: 0 }],
      currentDatabase: { name: "Dictionary" },
    };
  },
  methods: {
    queryList() {
      const criteria = this.searchType.target;
      const condition = new RegExp(this.query);
      console.log(
        "Result is: ",
        this.databases[this.databases.length - 1].data.filter(function (elem) {
          return condition.test(elem[criteria]);
        })
      );
      const result = this.databases[this.databases.length - 1].data.filter(
        function (elem) {
          return condition.test(elem[criteria]);
        }
      );
      // const result = this.databases[0].filter(function (el) {
      //   return condition.test(el[criteria]);
      // });
      this.currentResult = result;
      this.databases.push({
        name: `${this.searchType.Lang}: ${this.query}`,
        data: result,
        level: this.databases.length,
      });
      console.log(this.databases);
    },
    resetSearch(targetLevel) {
      this.databases.splice(targetLevel + 1);
      //   this.databases.splice(0, this.databases.length);
      //   this.databases = [{ name: "Dictionary", data: this.dictionary }];
      if (targetLevel === 0) {
        this.currentResult = "";
      } else {
        this.currentResult = this.databases[this.databases.length - 1].data;
      }
    },
    populateDictionary() {
      return this.dictionaryData;
    },
    setSearchType(type) {
      this.searchType = type;
    },
  },
};
</script>

<style scoped>
.button:hover {
  background-color: #002ead;
  transition: 0.7s;
}

.button:active {
  background-color: #ffbf00;
}

button:focus {
  background: olive;
}
</style>
