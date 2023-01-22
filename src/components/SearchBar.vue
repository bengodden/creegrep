<template>
  <div class="searchresults-wrapper" ref="parentOfDatabases">
    <div v-for="data in databases" :key="data.name" class="databases">
      <button @click="resetSearch(data.level)" class="mainbutton">
        {{ data.name }}
      </button>
    </div>
  </div>

  <div>
    <div class="querybar">
      <div id="input=wrapper" v-if="!this.menuVisible">
        <input
          type="text"
          v-on:keyup.enter="queryList()"
          v-model="query"
          placeholder="kīkwāy ē-natonaman?"
        />
      </div>
      <div class="dropdown" v-if="this.menuVisible">
        <button class="dropbtn">Word Type</button>
        <div class="dropdown-content">
          <a v-for="item in menuItems" :key="item" @click="menuSetQuery(item)">
            {{ item }}
          </a>
        </div>
      </div>
      <button @click="queryList()" class="searchbutton mainbutton">
        Search
      </button>
      <div id="search-types">
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
  </div>
  <div class="results-wrapper" v-if="currentResult.length > 0">
    <div
      v-for="result in currentResult"
      :key="result._id"
      class="result-class row"
    >
      <a
        v-bind:href="'https://itwewina.altlab.app/search?q=' + result.lemma"
        class="result-col-one"
        ><button class="result-button">{{ result.lemma }}</button>
      </a>
      <div class="result-col-two">{{ result.definition }}</div>
      <div class="result-col-three">{{ result.verbtype }}</div>
    </div>
  </div>
  <div v-else class="noresults">{{ noResult }}</div>
</template>

<script>
import dictionaryData from "../data/cwDictionary.json";
export default {
  created() {
    this.dictionary = dictionaryData;
  },
  data() {
    return {
      query: "",
      dictionary: [],
      currentResult: [],
      cachedResults: [{}],
      searchTypes: [
        { Lang: "nēhiyawēwin", target: "lemma", status: true },
        { Lang: "English", target: "definition", status: false },
        { Lang: "Word Type", target: "verbtype", status: false },
      ],
      searchType: { Lang: "nēhiyawēwin", target: "lemma", status: true },
      databases: [
        {
          name: "Dictionary",
          data: dictionaryData,
          level: 0,
        },
      ],
      currentDatabase: { name: "Dictionary" },
      noResult: "Please enter something to search for.",
      menuItems: [
        "NA",
        "NI",
        "VII",
        "VAI",
        "VTI",
        "VTA",
        "INM",
        "IPC",
        "IPJ",
        "NA-1",
        "NA-2",
        "NA-3",
        "NI-1",
        "NI-2",
        "NI-3",
        "VAI-1",
        "VAI-2",
        "VAI-3",
        "VII-1n",
        "VII-1v",
        "VII-2n",
        "VII-2v",
        "VTA-1",
        "VTA-2",
        "VTA-3",
        "VTA-4",
        "VTA-5",
        "VTI-1",
        "VTI-2",
        "VTI-3",
      ],
      menuVisible: false,
    };
  },
  methods: {
    queryList() {
      if (this.query === "") {
        console.log("this.query in first if statement is: ", this.query);
        this.currentResult = [];
        this.noResult =
          "Nothing Entered. Please enter something to search for.";
      } else {
        const criteria = this.searchType.target;
        const condition = new RegExp(this.replaceMacrons(this.query));
        console.log("this.databases.length is: ", this.databases[0].data);
        const result = this.databases[this.databases.length - 1].data.filter(
          function (elem) {
            return condition.test(elem[criteria]);
          }
        );
        if (result == "") {
          this.currentResult = [];
          this.noResult = "Nothing Found.";
        } else {
          console.log("Result is: ", result);
          this.currentResult = result;
          this.databases.push({
            name: `${this.searchType.Lang}: ${condition}`,
            data: result,
            level: this.databases.length,
            color: this.randomColour(),
          });
        }
      }
    },
    resetSearch(targetLevel) {
      this.databases.splice(targetLevel + 1);
      //   this.databases.splice(0, this.databases.length);
      //   this.databases = [{ name: "Dictionary", data: this.dictionary }];
      if (targetLevel === 0) {
        this.currentResult = "";
        this.noResult = "Please enter something to search for.";
      } else {
        this.currentResult = this.databases[this.databases.length - 1].data;
      }
    },
    populateDictionary() {
      return this.dictionaryData;
    },
    setSearchType(type) {
      this.searchTypes.forEach((element) => {
        if (element.Lang === type.Lang) {
          element.status = true;
        } else {
          element.status = false;
        }
      });
      if (type.target === "verbtype") {
        this.menuVisible = true;
      } else {
        this.menuVisible = false;
      }
      this.searchType = type;
    },
    randomColour() {
      const randomBetween = (min, max) =>
        min + Math.floor(Math.random() * (max - min + 1));
      const r = randomBetween(0, 255);
      const g = randomBetween(0, 255);
      const b = randomBetween(0, 255);
      const randomColor = `rgba(${r},${g},${b}, 0.3)`;
      return randomColor;
    },
    replaceMacrons(query) {
      return query
        .replaceAll("ā", "â")
        .replaceAll("ē", "ê")
        .replaceAll("ō", "ô")
        .replaceAll("ī", "î")
        .replaceAll("ý", "y");
    },
    menuSetQuery(item) {
      this.query = item;
    },
    toggleMenu() {
      this.menuVisible = !this.menuVisible;
    },
  },
};
</script>

<style scoped>
input {
  font-size: 14px;
  outline: none;
  border-radius: 10px;
  box-shadow: 0 9px #999;
  padding: 10px 15px;
}
.result-button {
  padding: 5px 15px;
  font-size: 16px;
  text-align: center;
  cursor: pointer;
  outline: none;
  color: #fff;
  background-color: #359267;
  border: none;
  border-radius: 15px;
  box-shadow: 0 9px #999;
  transition: 0.4s;
}
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
  transition: 0.4s;
}
button:hover {
  background-color: #8e3e87;
  transition: 0.4s;
}
button:active {
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

.stactive {
  background-color: #3e858e;
}

.searchresults-wrapper {
  display: flex;
  flex-direction: row;
  flex-flow: wrap;
}
.querybar {
  display: flex;
  flex-direction: row;
  justify-content: right;
  flex-flow: nowrap;
  gap: 30px 10px;
}
#search-types {
  display: flex;
  flex-direction: row;
  gap: 0px 0px;
}

.results-wrapper {
  margin: 30px 0px;
}
.result-class {
  display: flex;
  flex-direction: row;
  align-items: stretch;
}
.result-col-one {
  flex: 2 0 15%;
  margin: 10px;
}
.result-col-two {
  flex: 5 4 75%;
  margin: 10px;
}
.result-col-three {
  flex: 1 1 10%;
  margin: 10px;
}
.row:nth-child(odd) {
  background: #e0e0e0;
}
.noresults {
  text-align: center;
  margin: 40px;
  font-size: x-large;
  text-shadow: 4px 6px 6px rgba(46, 91, 173, 0.6);
}
/* Dropdown Button */
.dropbtn {
  background-color: #359267;
  border: none;
  border-radius: 15px;
  box-shadow: 0 9px #999;
  transition: 0.4s;
  padding: 10px 65px;
  font-size: 14px;
  text-align: center;
  cursor: pointer;
  outline: none;
  color: #fff;
}

/* The container <div> - needed to position the dropdown content */
.dropdown {
  position: relative;
  display: inline-block;
  text-align: center;
}

/* Dropdown Content (Hidden by Default) */
.dropdown-content {
  display: none;
  position: absolute;
  background-color: #359267;
  min-width: 160px;
  box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
  z-index: 1;
  padding: 10px 15px;
}

/* Links inside the dropdown */
.dropdown-content a {
  color: rgb(255, 255, 255);
  padding: 12px 16px;
  text-decoration: none;
  display: block;
}

/* Change color of dropdown links on hover */
.dropdown-content a:hover {
  background-color: #ddd;
}

/* Show the dropdown menu on hover */
.dropdown:hover .dropdown-content {
  display: block;
}

/* Change the background color of the dropdown button when the dropdown content is shown */
.dropdown:hover .dropbtn {
  background-color: #3e8e41;
}
</style>
