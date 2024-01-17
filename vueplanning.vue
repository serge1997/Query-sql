<template>
  <div id="app">
  <div class="container text-center">
    <div class="row d-flex">
      <div v-for="(day, index) in week" class="col">
        <div class="p-3">{{ day.day }}</div>
        <button v-for="(tal, index) in users" :id="`btn-${index}-${day.day.substring(3, 6)}`" class="btn bg-white border mt-4 p-3 form-control" data-bs-toggle="modal" data-bs-target="#exampleModal" @click="createID(index, day.day)"></button>
      </div>
    </div>
    <div class="modal fade" id="exampleModal" aria-hidden="true" aria-labelledby="exampleModal" tabindex="-1">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h1 class="modal-title fs-5" id="exampleModalToggleLabel">Escolhe usuario</h1>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <select v-model="selectedUser" class="p-2 form-control">
              <option v-for="user in users" :value="user.name">{{ user.name }}</option>
            </select>
          </div>
          <div class="modal-footer">
            <button @click="save" class="btn btn-primary" data-bs-target="#exampleModalToggle2" data-bs-toggle="modal">Ok</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>


export default {
  name: 'App',
  components: {
  
  },
  data(){
    return {
      week: [
        {day: "15 seg"},
        {day: "15 ter"},
        {day: "15 qua"},
        {day: "15 qui"},
        {day: "15 sex"},
        {day: "15 sab"},
        {day: "15 dom"},
      ],
      users: [
        {name: "Pedro"},
        {name: "David"},
        {name: "Silva"},
        {name: "Matheus"},
        {name: "Diana"},
      ],
      planning: [],
      selectedUser: null
    }
  },
  methods: {
    createID(index, day){
      localStorage.removeItem('id')
      let dy = day.substring(3, 6);
      localStorage.setItem("id", `btn-${index}-${dy}`);
    },

    save(){
      let id = localStorage.getItem('id');
      let dynamic = document.getElementById(`${id}`);
      dynamic.setAttribute("class", "")
      this.planning.push(this.selectedUser)
      for (let i = 0; i < this.planning.length; i++){
        dynamic.textContent = this.planning[i] 
        
        dynamic.setAttribute("class", 'btn btn-warning border mt-4 p-3 form-control')
      }
    }
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
