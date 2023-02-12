<template>
  <header></header>
  <div class="searchresults-wrapper" ref="parentOfDatabases">
    <div v-for="data in databases" :key="data.name" class="databases">
      <div @click="resetSearch(data.level)" class="btn">
        {{ data.name }}
      </div>
    </div>
  </div>

  <div class="query-wrapper">
    <div id="input-wrapper">
      <input
        type="text"
        v-on:keyup.enter="queryList(query, searchType.target, false)"
        v-on:keyup.esc="resetSearch(0)"
        v-on:keyup.down="nextSearchType()"
        v-on:keyup.up="previousSearchType()"
        v-model="query"
        placeholder="kīkwāy ē-natonaman?"
        id="search-input"
      />
    </div>

    <div
      @click="queryList(query, searchType.target, false)"
      class="searchbutton mainbutton"
    >
      Search
    </div>

    <div id="search-types">
      <div v-for="type in searchTypes" :key="type.Lang">
        <button
          @click="
            setSearchType(type);
            showMenu('verbType', 'verbMenu', type.target);
          "
          :class="{ stactive: type.status, stbutton: true }"
          :id="type.target"
        >
          {{ type.Lang }}
        </button>
      </div>
      <div class="dropdown-verbtype" id="verbMenu">
        <div class="dropdown-content" :style="`display:${verbMenu}`">
          <a
            v-for="item in menuItems"
            :key="item"
            @click="menuSetQuery(item, searchType.target, false)"
          >
            {{ item }}
          </a>
        </div>
      </div>
    </div>
  </div>

  <div class="results-wrapper" v-if="currentResult.length > 0">
    <div
      v-for="result in currentPageItems"
      :key="result._id"
      class="result-class row"
    >
      <a
        v-bind:href="'https://itwewina.altlab.app/search?q=' + result.lemma"
        class="result-col-one"
        ><div class="result-button">{{ result.lemma }}</div>
      </a>
      <div class="result-col-two">{{ result.definition }}</div>
      <div class="result-col-three">{{ result.verbtype }}</div>
    </div>
  </div>
  <div v-else class="noresults">{{ noResult }}</div>

  <div class="navbtn-wrapper">
    <div
      @click="displayResults('back')"
      class="navbtn"
      v-bind:class="isBackBtnDisabled ? 'navbtn-disabled' : 'navbtn'"
    >
      Back
    </div>
    <div
      @click="displayResults('next')"
      class="navbtn"
      v-bind:class="isNextBtnDisabled ? 'navbtn-disabled' : 'navbtn'"
    >
      Next
    </div>
    <div class="dropdown">
      <div class="dropbtn-ranges" @click="showMenu('ranges')">
        {{ this.displayResult }}-
        {{
          this.displayResult + this.displayPerPage >= this.currentResult.length
            ? this.currentResult.length
            : this.displayResult + this.displayPerPage
        }}
        of:
        {{ this.currentResult.length }}
      </div>
      <div class="dropdown-ranges" :style="`display:${rangeMenu}`">
        <a
          v-for="amount in displayRanges"
          :key="amount"
          @click="
            this.displayPerPage = amount;
            this.rangeMenu = 'none';
          "
        >
          {{ amount }}
        </a>
      </div>
    </div>
  </div>

  <span class="copyright"> {{ copyright }}</span>
</template>

<script>
import dictionaryData from "../data/cwDictionary.json";
import SearchBar from "../components/SearchBar.vue";
import HomeView from "../views/HomeView.vue";
export default {
  created() {
    this.dictionary = dictionaryData;
    if (this.$route.params.searchedTerms && this.$route.params.searchedTypes) {
      const urlTerms = this.$route.params.searchedTerms.split("-");
      const urlTypes = this.$route.params.searchedTypes.split("-");

      urlTerms.forEach((term, index) => {
        this.queryList(term, urlTypes[index], true);
      });
    }
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
          query: "",
          searchType: "",
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
        "NUM",
      ],
      menuVisible: false,
      displayPerPage: 25,
      displayResult: 0,
      displayRanges: [25, 15, 50],
      copyright:
        "Please note that this tool for educational purposes only. All data is from https://itwewina.altlab.app/ and all rights remain with the content creators.",
      rangeMenu: "none",
      verbMenu: "none",
    };
  },
  methods: {
    queryList(query, searchType, deepLink) {
      this.displayResult = 0;
      if (query == "") {
        this.currentResult = [];
        this.noResult =
          "Nothing Entered. Please enter something to search for.";
      } else {
        if (searchType == "lemma") {
          query = query.toLowerCase();
        }
        const condition = new RegExp(this.replaceMacrons(query));
        console.log("REGIX condition is: ", condition);
        const result = this.databases[this.databases.length - 1].data.filter(
          function (elem) {
            return condition.test(elem[searchType]);
          }
        );
        if (result == "") {
          this.currentResult = [];
          this.noResult = "Nothing Found.";
        } else {
          this.currentResult = result;
          this.databases.push({
            name: `${this.searchType.Lang}: ${condition}`,
            query: query,
            searchType: searchType,
            data: result,
            level: this.databases.length,
          });
          if (deepLink === false) {
            let pushTerms = "";
            let pushTypes = "";
            if (
              this.$route.params.searchedTerms &&
              this.$route.params.searchedTypes
            ) {
              pushTerms = `${this.$route.params.searchedTerms}-${query}`;
              pushTypes = `${this.$route.params.searchedTypes}-${searchType}`;
            } else {
              pushTerms = `${query}`;
              pushTypes = `${searchType}`;
            }
            this.$router.push(`/${pushTerms}/${pushTypes}`);
          }
        }
      }
    },
    resetSearch(targetLevel) {
      this.databases.splice(targetLevel + 1);
      if (targetLevel === 0) {
        //Resetting to initial setup
        this.$router.replace({
          name: "home",
          path: "/",
          component: HomeView,
          children: [
            { path: ":searchedTerms", component: SearchBar },
            { path: ":searchedTerms/:searchedTypes", component: SearchBar },
          ],
        });
        this.currentResult = "";
        this.noResult = "Please enter something to search for.";
      } else {
        this.currentResult = this.databases[this.databases.length - 1].data;
        let Terms = "";
        let Types = "";
        this.databases.forEach((element, index) => {
          if (index > 1) {
            Terms += "-";
            Types += "-";
          }
          Terms += element.query;
          Types += element.searchType;
        });
        this.$router.push(`/${Terms}/${Types}`);
      }
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
      this.queryList(item, this.searchType.target, false);
    },
    displayResults(direction) {
      if (direction == "next") {
        this.displayResult = this.displayResult + this.displayPerPage;
      } else {
        if (this.displayPerPage <= this.displayResult) {
          this.displayResult = this.displayResult - this.displayPerPage;
        } else {
          this.displayResult = 0;
        }
      }
    },
    isDisabled(buttonName) {
      if (buttonName == "back" && this.displayResult == 0) {
        return true;
      }
    },
    showMenu(menuType, element, parent) {
      if (menuType == "ranges") {
        if (this.rangeMenu == "none") {
          this.rangeMenu = "block";
        } else {
          this.rangeMenu = "none";
        }
      } else if (menuType == "verbType") {
        if (this.searchType.target == "verbtype" && this.verbMenu == "none") {
          const el = document.getElementById(element);
          const par = document.getElementById(parent);
          par.appendChild(el);
          this.verbMenu = "block";
        } else {
          this.verbMenu = "none";
        }
      } else {
        this.verbMenu = "none";
      }
    },
    nextSearchType() {
      const currentIndex = this.searchTypes.findIndex(
        (element) => element.Lang == this.searchType.Lang
      );
      this.showMenu("null");
      if (currentIndex == this.searchTypes.length - 1) {
        this.setSearchType(this.searchTypes[0]);
      } else {
        this.setSearchType(this.searchTypes[currentIndex + 1]);
      }
    },
    previousSearchType() {
      const currentIndex = this.searchTypes.findIndex(
        (element) => element.Lang == this.searchType.Lang
      );
      this.showMenu("null");
      if (currentIndex == 0) {
        this.setSearchType(this.searchTypes[this.searchTypes.length - 1]);
      } else {
        this.setSearchType(this.searchTypes[currentIndex - 1]);
      }
    },
  },
  computed: {
    currentPageItems() {
      return this.currentResult.slice(
        this.displayResult,
        this.displayResult + this.displayPerPage
      );
    },
    isBackBtnDisabled() {
      return this.displayResult == 0 ? true : false;
    },
    isNextBtnDisabled() {
      return this.displayResult + this.displayPerPage >=
        this.currentResult.length
        ? true
        : false;
    },
  },
};
</script>

<style scoped>
.btn {
  display: inline-block;
  padding: 6px 12px;
  margin-bottom: 0;
  font-size: 14px;
  font-weight: 400;
  line-height: 1.42857143;
  text-align: center;
  white-space: nowrap;
  vertical-align: middle;
  -ms-touch-action: manipulation;
  touch-action: manipulation;
  cursor: pointer;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
  background-image: none;
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

.btn:hover {
  color: #333;
  background-color: #e6e6e6;
  border-color: #adadad;
}

.btn:active {
  background-color: #3e8e41;
  box-shadow: 0 5px #666;
  transform: translateY(4px);
}

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
  white-space: nowrap;
  vertical-align: middle;
  -ms-touch-action: manipulation;
  touch-action: manipulation;
  cursor: pointer;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
  background-image: none;
  padding: 10px 15px;
}

.result-button:hover {
  color: rgb(255, 255, 255);
  background-color: #8e3e87;
  transition: 0.4s;
}

.result-button:active {
  background-color: #3e8e41;
  box-shadow: 0 5px #666;
  transform: translateY(4px);
}
.mainbutton {
  padding: 10px 15px;
  font-size: 14px;
  text-align: center;
  line-height: 1.42857143;
  text-align: center;
  white-space: nowrap;
  vertical-align: middle;
  -ms-touch-action: manipulation;
  touch-action: manipulation;
  cursor: pointer;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
  background-image: none;
  padding: 10px 15px;
  cursor: pointer;
  outline: none;
  color: #fff;
  background-color: #0099cc;
  border: none;
  border-radius: 15px;
  box-shadow: 0 9px #999;
  transition: 0.4s;
}

.mainbutton:hover {
  color: rgb(255, 255, 255);
  background-color: #8e3e87;
  transition: 0.4s;
}

.mainbutton:active {
  background-color: #3e8e41;
  box-shadow: 0 5px #666;
  transform: translateY(4px);
}

.navbtn {
  padding: 10px 15px;
  font-size: 14px;
  text-align: center;
  line-height: 1.42857143;
  white-space: nowrap;
  vertical-align: middle;
  -ms-touch-action: manipulation;
  touch-action: manipulation;
  cursor: pointer;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
  background-image: none;
  padding: 10px 15px;
  cursor: pointer;
  outline: none;
  color: #fff;
  background-color: #0099cc;
  border: none;
  border-radius: 15px;
  box-shadow: 0 9px #999;
  transition: 0.4s;
}

.navbtn:hover {
  color: rgb(255, 255, 255);
  background-color: #8e3e87;
  transition: 0.4s;
}

.navbtn:active {
  background-color: #3e8e41;
  box-shadow: 0 5px #666;
  transform: translateY(4px);
}

.navbtn-disabled {
  color: rgb(76, 76, 76);
  background-color: #bebebe;
  box-shadow: 0 5px #666;
  pointer-events: none;
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
button:disabled,
button[disabled] {
  border: 1px solid #999999;
  background-color: #cccccc;
  color: #666666;
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

.query-wrapper {
  display: flex;
  flex-direction: row;
  justify-content: right;
  flex-flow: nowrap;
  gap: 30px 10px;
}
.results-wrapper {
  margin: 30px 0px;
}
.navbtn-wrapper {
  display: flex;
  flex-direction: row;
  flex-flow: wrap;
  justify-content: right;
  gap: 0px 10px;
  margin: 30px 0px;
}

.copyright {
  display: block;
  justify-content: center;
  font-size: 14px;
  text-align: center;
  text-shadow: 4px 6px 6px rgba(96, 108, 8, 0.6);
}

#search-types {
  display: flex;
  flex-direction: row;
  gap: 0px 0px;
}

.result-class {
  display: flex;
  flex-direction: row;
  align-items: stretch;
}
.result-col-one {
  flex: 2 0 15%;
  margin: 10px;
  order: 1;
}
.result-col-two {
  flex: 5 4 75%;
  margin: 10px;
  order: 2;
}
.result-col-three {
  flex: 1 1 10%;
  margin: 10px;
  order: 3;
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
  padding: 10px 15px;
  font-size: 14px;
  text-align: center;
  line-height: 1.42857143;
  text-align: center;
  white-space: nowrap;
  vertical-align: middle;
  -ms-touch-action: manipulation;
  touch-action: manipulation;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
  background-image: none;

  transition: 0.4s;
}

/* The container <div> - needed to position the dropdown content */
.dropdown {
  position: relative;
  display: inline-block;
  text-align: center;
}

.dropdown-verbtype {
  position: absolute;
  display: block;
  text-align: center;
  margin: 10px -10px;
}
/* Dropdown Content (Hidden by Default) */
.dropdown-content {
  display: block;
  position: absolute;
  background-color: #359267;
  min-width: 75px;
  box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
  z-index: 1;
  padding: 2px 5px;
  top: 100%;
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

/* Dropdown Content (Hidden by Default) */
.dropdown-ranges {
  position: absolute;
  background-color: #359267;
  min-width: 25px;
  box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
  z-index: 1;
  padding: 10px 15px;
  bottom: 100%;
}
/* Links inside the dropdown */
.dropdown-ranges a {
  color: rgb(255, 255, 255);
  padding: 12px 16px;
  text-decoration: none;
  display: block;
}
/* Change color of dropdown links on hover */
.dropdown-ranges a:hover {
  background-color: #ddd;
}
.dropbtn-ranges {
  background-color: #359267;
  border: none;
  border-radius: 15px;
  box-shadow: 0 9px #999;
  transition: 0.4s;
  padding: 10px 25px;
  font-size: 14px;
  text-align: center;
  cursor: pointer;
  outline: none;
  color: #fff;
}
.copyright {
  text-align: center;
  margin: 40px;
  font-size: large;
  text-shadow: 4px 6px 6px rgba(96, 108, 8, 0.6);
}

@media (max-width: 480px) {
  .databases {
    flex: 0 0 90%;
  }

  .query-wrapper {
    display: flex;
    flex-direction: row;
    justify-content: center;
    flex-flow: wrap;
    gap: 10px 0px;
  }

  #input-wrapper {
    flex: 0 0 95%;
    width: 90%;
    display: flex;
    margin-top: 10px;
  }

  .mainbutton {
    flex-basis: 90%;
    width: 100%;
  }
  .btn {
    width: 100%;
    flex-basis: 90%;
  }
  input {
    width: 90%;
    font-size: 14px;
    outline: none;
    border-radius: 10px;
    box-shadow: 0 9px #999;
    padding: 10px 35px;
  }

  .navbtn-wrapper {
    display: flex;
    flex-direction: row;
    justify-content: center;
    flex-flow: wrap;
    gap: 10px 2px;
  }

  .navbtn {
    flex-basis: 20%;
  }

  .result-class {
    display: flex;
    flex-direction: row;
    align-items: center;
    flex-wrap: wrap;
  }
  .result-col-one {
    flex: 5 0 15%;
    margin: 10px;
    order: 1;
  }
  .result-col-two {
    flex: 5 4 75%;
    margin: 10px;
    order: 3;
    flex-basis: 100%;
    text-align: center;
  }
  .result-col-three {
    flex: 1 1 10%;
    margin: 10px;
    order: 2;
  }
}
</style>
