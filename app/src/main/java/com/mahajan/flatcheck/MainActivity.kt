package com.mahajan.flatcheck

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

private data class Flat(val name:String,val price:Double,val carpet:Double,val possession:Int,val commute:Int,val vastu:Int){
    val score:Int get() = ((carpet/800)*25 + (1-price/100)*25 + (commute/10)*25 + (possession/2031.0)*15 + vastu*10).toInt().coerceIn(0,100)
}

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) { super.onCreate(savedInstanceState); setContent { FlatCheckApp() } }
}

@Composable fun FlatCheckApp(){
    var flats by remember { mutableStateOf(listOf<Flat>()) }
    var name by remember { mutableStateOf("") }; var price by remember { mutableStateOf("") }; var carpet by remember { mutableStateOf("") }
    var possession by remember { mutableStateOf("") }; var commute by remember { mutableStateOf("") }
    MaterialTheme {
        Scaffold(topBar={TopAppBar(title={Text("FlatCheck V2")})}) { pad ->
            LazyColumn(Modifier.padding(pad).padding(16.dp), verticalArrangement=Arrangement.spacedBy(10.dp)) {
                item { Text("Compare flats smarter", style=MaterialTheme.typography.headlineSmall); Text("Add price, carpet area and practical scores to see your best option.") }
                item { OutlinedTextField(name,{name=it},label={Text("Project / Flat")},modifier=Modifier.fillMaxWidth()) }
                item { OutlinedTextField(price,{price=it},label={Text("Total price (₹ lakh)")},modifier=Modifier.fillMaxWidth()) }
                item { OutlinedTextField(carpet,{carpet=it},label={Text("Carpet area (sq ft)")},modifier=Modifier.fillMaxWidth()) }
                item { OutlinedTextField(possession,{possession=it},label={Text("Possession year")},modifier=Modifier.fillMaxWidth()) }
                item { OutlinedTextField(commute,{commute=it},label={Text("Commute score 0–10")},modifier=Modifier.fillMaxWidth()) }
                item { Button(onClick={ if(name.isNotBlank() && price.toDoubleOrNull()!=null && carpet.toDoubleOrNull()!=null && possession.toIntOrNull()!=null && commute.toIntOrNull()!=null){ flats=flats+Flat(name,price.toDouble(),carpet.toDouble(),possession.toInt(),commute.toInt()); name="";price="";carpet="";possession="";commute="" } },modifier=Modifier.fillMaxWidth()){Text("Add flat") } }
                item { if(flats.isNotEmpty()) Text("Your comparison", style=MaterialTheme.typography.titleLarge) }
                items(flats.sortedByDescending{it.score}) { f -> Card(Modifier.fillMaxWidth()){Column(Modifier.padding(16.dp)){Text(f.name,style=MaterialTheme.typography.titleMedium);Text("₹${"%.1f".format(f.price)}L  •  ${f.carpet.toInt()} sq ft  •  possession ${f.possession}");Text("Commute ${f.commute}/10  •  Overall score ${f.score}/100")}} }
            }
        }
    }
}
