<template>
  <div>
    <div v-for="data in databases" :key="data.name" id="database">
      <input type="radio" :id="data" :value="data" v-model="currentDatabase" />
      <label :for="data">{{ data.name }}</label>
    </div>
    <input type="text" v-model="query" placeholder="kīkwāy ē-natonaman?" />
    <div v-for="type in searchTypes" :key="type.Lang" id="typeOfSearch">
      <input type="radio" :id="type" :value="type" v-model="searchType" />
      <label :for="type">{{ type.Lang }}</label>
    </div>
    <button @click="queryList()">Search</button>
  </div>

  <div v-for="result in currentResult" :key="result._id">
    <a v-bind:href="'https://itwewina.altlab.app/search?q=' + result.lemma"
      >{{ result.lemma }}
    </a>
    <span>{{ result.definition }}</span>
  </div>
</template>

<script>
import data from "../data/cwDictionary.json";
export default {
  created() {
    this.dictionary = data;
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
      databases: [
        { name: "Dictionary", data: this.dictionary },
        { name: "Results", data: "last Result" },
      ],
      currentDatabase: { name: "Dictionary" },
    };
  },
  methods: {
    queryList() {
      const criteria = this.searchType.target;
      const condition = new RegExp(this.query);
      console.log("FROM QUERYLIST:", this.currentDatabase.data);
      const result = this.dictionary.filter(function (el) {
        return condition.test(el[criteria]);
      });
      this.currentResult = result;
    },
  },
};
</script>
