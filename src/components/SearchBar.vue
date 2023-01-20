<template>
  <div class="searchresult">
    <div
      v-for="data in databases"
      :key="data.name"
      id="database"
      :style="{ backgroundColor: data.color }"
    >
      <button @click="resetSearch(data.level)" class="mainbutton">
        {{ data.name }}
      </button>
    </div>

    <div class="flexcontainer">
      <input type="text" v-model="query" placeholder="kīkwāy ē-natonaman?" />
      <button @click="queryList('none')" class="searchbutton mainbutton">
        Search
      </button>
      <div v-for="type in searchTypes" :key="type.Lang">
        <button
          @click="setSearchType(type)"
          :class="{ stactive: type.status, stbutton: true }"
          :id="type.Lang"
        >
          {{ type.Lang }}
        </button>
      </div>
    </div>
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
        { Lang: "nēhiyawēwin", target: "lemma", status: true },
        { Lang: "English", target: "definition", status: false },
        { Lang: "Verb Type", target: "verbtype", status: false },
      ],
      searchType: { Lang: "nēhiyawēwin", target: "lemma", status: true },
      databases: [
        {
          name: "Dictionary",
          data: dictionaryData,
          level: 0,
          color: this.randomColour(),
        },
      ],
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
        color: this.randomColour(),
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
      console.log("type is: ", type);
      this.searchTypes.forEach((element) => {
        if (element.Lang === type.Lang) {
          element.status = true;
        } else {
          element.status = false;
        }
      });
      this.searchType = type;
    },
    randomColour() {
      const randomBetween = (min, max) =>
        min + Math.floor(Math.random() * (max - min + 1));
      const r = randomBetween(0, 255);
      const g = randomBetween(0, 255);
      const b = randomBetween(0, 255);
      const randomColor = `rgba(${r},${g},${b}, 0.1)`;
      return randomColor;
    },
  },
};
</script>

<style scoped>
.mainbutton {
  padding: 10px 15px;
  font-size: 14px;
  text-align: center;
  cursor: pointer;
  outline: none;
  color: #fff;
  background-color: #0099cc;
  border: none;
  border-radius: 15px;
  box-shadow: 0 9px #999;
}
.mainbutton:hover {
  background-color: #8e3e87;
}
.mainbutton:active {
  background-color: #3e8e41;
  box-shadow: 0 5px #666;
  transform: translateY(4px);
}

.mainbutton .searchbutton {
  background-color: #3366ff;
}
.stbutton {
  background-color: #22a545;
  padding: 5px 10px;
  font-size: 14px;
  text-align: center;
  cursor: pointer;
  outline: none;
  color: #fff;
  border: none;
  /* border-radius: 10px; */
  box-shadow: 0 4px #999;
}
.stbutton:hover {
  background-color: #8e3e87;
}
.searchresult {
  width: 100%;
}

.stactive {
  background-color: #3e858e;
}
.flexcontainer {
  display: flex; /* or inline-flex */
  flex-direction: row;
  flex-wrap: wrap;
}

.container {
  display: flex; /* or inline-flex */
  flex-direction: row;
  flex-wrap: wrap;
}
</style>
